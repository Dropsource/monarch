import 'dart:io';
import 'dart:convert';

import 'package:args/args.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:monarch_utils/timers.dart';
import 'utils_local.dart' as local_utils;
import 'package:path/path.dart' as p;
import 'paths.dart';

bool verbose = false;

/// Run all unit and integration tests in all monarch modules using
/// all the fluter sdks in local_settings.yaml:
///
///   $ dart tools/test.dart --all
///
/// Run tests on a specific module:
///
///   $ dart tools/test.dart -m cli
///   $ dart tools/test.dart -m packages/monarch
///   $ dart tools/test.dart -m test/test_stories
///
/// To get more details:
///
///   $ dart tools/test.dart -h
///
/// Also see test/README.md
void main(List<String> arguments) async {
  var parser = ArgParser();

  parser.addFlag('help', abbr: 'h');
  parser.addOption('module',
      abbr: 'm',
      help:
          'The relative path to the monarch module to test; such as: cli, package/monarch, test/test_create, etc. '
          'By default, it will test all modules.');
  parser.addOption('flutter-sdk',
      abbr: 'f',
      help:
          'Path to the Flutter SDK to use. If blank, this command will run using '
          'each Flutter SDK declared in local_settings.yaml.');
  parser.addOption('monarch-dir',
      help:
          'Path to the Monarch binaries directory. Used by integration tests. '
          'Defaults to out/monarch');
  parser.addFlag('verbose',
      abbr: 'v', help: 'Runs tests in verbose mode', defaultsTo: false);

  var args = parser.parse(arguments);

  if (args['help']) {
    print(parser.usage);
    exit(0);
  }

  verbose = args['verbose'];
  String? flutter_sdk = args['flutter-sdk'];
  String? module = args['module'];
  String monarch_dir = args['monarch-dir'] ?? local_out_paths.out_monarch;
  String monarch_exe_ = monarch_exe(monarch_dir);

  Map<String, List<TestResult>> results;
  var stopwatch = Stopwatch()..start();

  if (flutter_sdk == null) {
    if (module == null) {
      results = await testAllModulesAllFlutterSdks(monarch_exe_);
    } else {
      results = await testSingleModuleAllFlutterSdks(module, monarch_exe_);
    }
  } else {
    String flutter_exe_ = flutter_exe(flutter_sdk);
    if (module == null) {
      results =
          await testAllModulesSingleFlutterSdk(flutter_exe_, monarch_exe_);
    } else {
      results = await testSingleModuleSingleFlutterSdk(
          flutter_exe_, monarch_exe_, module);
    }
  }

  printResults(results, stopwatch);
  exit_(results);
}

Future<Map<String, List<TestResult>>> testAllModulesAllFlutterSdks(
    String monarch_exe_) async {
  var resultsMap = <String, List<TestResult>>{};

  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    var results = await testAllModulesSingleFlutterSdk(
        flutter_exe(flutter_sdk), monarch_exe_);
    resultsMap[flutter_sdk] = results[flutter_sdk]!;
  }

  return resultsMap;
}

Future<Map<String, List<TestResult>>> testSingleModuleAllFlutterSdks(
    String module, String monarch_exe_) async {
  var resultsMap = <String, List<TestResult>>{};

  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    var results = await _test(flutter_exe(flutter_sdk), monarch_exe_, module);
    resultsMap[flutter_sdk] = [results];
  }

  return resultsMap;
}

Future<Map<String, List<TestResult>>> testAllModulesSingleFlutterSdk(
    String flutter_exe_, String monarch_exe_) async {
  var results = <TestResult>[];

  results.add(await _test(flutter_exe_, monarch_exe_, 'cli'));
  results.add(await _test(flutter_exe_, monarch_exe_, 'controller'));
  results.add(await _test(flutter_exe_, monarch_exe_, 'packages/monarch'));
  results.add(
      await _test(flutter_exe_, monarch_exe_, 'packages/monarch_io_utils'));
  results
      .add(await _test(flutter_exe_, monarch_exe_, 'packages/monarch_utils'));
  results.add(await _test(flutter_exe_, monarch_exe_, 'test/test_create'));
  results
      .add(await _test(flutter_exe_, monarch_exe_, 'test/test_localizations'));
  results.add(await _test(flutter_exe_, monarch_exe_, 'test/test_stories'));
  results.add(await _test(flutter_exe_, monarch_exe_, 'test/test_themes'));

  return {flutter_exe_: results};
}

Future<Map<String, List<TestResult>>> testSingleModuleSingleFlutterSdk(
    String flutter_exe_, String monarch_exe_, String module) async {
  var result = await _test(flutter_exe_, monarch_exe_, module);

  return {
    flutter_exe_: [result]
  };
}

Future<TestResult> _test(
    String flutter_exe_, String monarch_exe_, String module) async {
  fine('');
  fine('### Running $module tests');
  var stopwatch = Stopwatch()..start();

  var module_path = p.join(local_repo_paths.root, module);
  var command = dartOrFlutter(module_path, flutter_exe_);

  printUsingCommand(command);

  var sdkVersion = isFlutter(module_path, flutter_exe_) || module.startsWith('test')
      ? await getFlutterVersion(flutter_exe_)
      : await getDartVersion(command);
  info('Testing $module using $sdkVersion...');

  fine('');
  fine('Running `$command pub get` in $module...');
  var xpg = await Process.start(command, ['pub', 'get'],
      workingDirectory: module_path, runInShell: Platform.isWindows);
  if (verbose) {
    stdout.addStream(xpg.stdout);
    stderr.addStream(xpg.stderr);
  }
  await xpg.exitCode;

  fine('');
  fine('Running `$command test` in $module...');
  var process = await Process.start(command, ['test'],
      workingDirectory: module_path,
      runInShell: Platform.isWindows,
      environment: {
        'MONARCH_EXE': monarch_exe_,
        'FLUTTER_EXE': flutter_exe_,
      });

  if (module.startsWith('test')) {
    fine('Integration tests environment variables:');
    fine('  - MONARCH_EXE: $monarch_exe_');
    fine('  - FLUTTER_EXE: $flutter_exe_');
  }

  if (verbose) {
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
  }
  var exitCode = await process.exitCode;
  var result = TestResult(module, exitCode);

  if (result.passed) {
    info('PASSED: $module using $sdkVersion. Took ${stopwatch..stop()}.');
  } else {
    info('FAILED: $module using $sdkVersion. Took ${stopwatch..stop()}.');
  }

  return result;
}

String dartOrFlutter(String module_path, String flutter_exe_) {
  if (isFlutter(module_path, flutter_exe_)) {
    return flutter_exe_;
  } else {
    return 'dart';
  }
}

bool isFlutter(String module_path, String flutter_exe_) {
  var pubspecFile = File(p.join(module_path, 'pubspec.yaml'));
  if (!pubspecFile.existsSync()) {
    throw 'pubspec.yaml of $module_path does not exist';
  }
  if (pubspecFile.readAsStringSync().contains('sdk: flutter')) {
    return true;
  } else {
    return false;
  }
}

void printResults(
    Map<String, List<TestResult>> resultsMap, Stopwatch stopwatch) {
  fine('''

### Test Results''');
  for (var key in resultsMap.keys) {
    fine('');
    printUsingCommand(key);
    for (var result in resultsMap[key]!) {
      fine('- $result');
    }
  }

  fine('');
  fine('Tests took ${stopwatch..stop()}.');
}

void exit_(Map<String, List<TestResult>> results) {
  var results_ = results.values.expand((element) => element).toList();
  if (results_.every((element) => element.passed)) {
    info('All tests passed.');
    exit(0);
  } else {
    info('Some tests FAILED.');
    exit(1);
  }
}

void printUsingCommand(String command) {
  if (command == 'dart' || command == 'flutter') {
    fine('Using $command exe from PATH');
  } else {
    fine('Using $command');
  }
}

Future<String> getFlutterVersion(String flutter_exe_) async {
  var result = await Process.run(
    flutter_exe_,
    ['--version'],
    stdoutEncoding: Platform.isWindows ? Utf8Codec() : systemEncoding,
    stderrEncoding: Platform.isWindows ? Utf8Codec() : systemEncoding,
  );
  if (result.exitCode == 0) {
    var output = result.stdout.toString().trim();
    var id = FlutterSdkId.parseFlutterVersionOutput(
        output, Platform.operatingSystem);
    return 'Flutter ${id.version} (${id.channel})';
  } else {
    throw '`flutter --version` did not exit successfully';
  }
}

Future<String> getDartVersion(String dart_exe_) async {
  var result = await Process.run(
    dart_exe_,
    ['--version'],
  );
  if (result.exitCode == 0) {
    var output = result.stdout.toString().trim();
    var pattern = RegExp(r'^Dart SDK version:\s(\S+)\s\((\w+)\)');
    if (pattern.hasMatch(output)) {
      var match = pattern.firstMatch(output)!;
      if (match.groupCount == 2) {
        var _version = match.group(1)!;
        var _channel = match.group(2)!;
        return 'Dart $_version ($_channel)';
      }
    }
    throw 'Could not parse version and channel from "dart --version" command output';
  } else {
    throw '`dart --version` did not exit successfully';
  }
}

void fine(String message) {
  if (verbose) print(message);
}

void info(String message) {
  print(message);
}

class TestResult {
  final String module;
  final int exitCode;
  bool get passed => exitCode == 0;

  TestResult(this.module, this.exitCode);

  @override
  String toString() => '$module tests ${exitCode == 0 ? 'passed' : 'FAILED'}';
}
