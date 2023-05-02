import 'dart:io';

import 'package:args/args.dart';
import 'package:monarch_utils/timers.dart';
import 'utils_local.dart' as local_utils;
import 'package:path/path.dart' as p;
import 'paths.dart';

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

  var args = parser.parse(arguments);

  if (args['help']) {
    print(parser.usage);
    exit(0);
  }

  String? flutter_sdk = args['flutter-sdk'];
  String? module = args['module'];
  String monarch_dir = args['monarch-dir'] ?? local_out_paths.out_monarch;
  String monarch_exe_ = monarch_exe(monarch_dir);

  if (flutter_sdk == null) {
    if (module == null) {
      var results = await runTestsUsingAllFlutterSdksOnAllModules(monarch_exe_);
      exit_(results);
    } else {
      var results = await runTestsUsingAllFlutterSdks(module, monarch_exe_);
      exit_(results);
    }
  } else {
    String flutter_exe_ = flutter_exe(flutter_sdk);
    if (module == null) {
      var results = await runTestsOnAllModules(flutter_exe_, monarch_exe_);
      exit_(results);
    } else {
      var result = await runTest(flutter_exe_, monarch_exe_, module);
      result.passed ? exit(0) : exit(1);
    }
  }
}

void exit_(List<TestResult> results) {
  if (results.every((element) => element.passed)) {
    print('All tests passed.');
    exit(0);
  } else {
    print('Some tests FAILED.');
    exit(1);
  }
}

Future<List<TestResult>> runTestsUsingAllFlutterSdksOnAllModules(String monarch_exe_) async {
  var stopwatch = Stopwatch()..start();
  var resultsMap = <String, List<TestResult>>{};

  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    var results = await runTestsOnAllModules(flutter_exe(flutter_sdk), monarch_exe_);
    resultsMap[flutter_sdk] = results;
  }

  printResults(resultsMap, stopwatch);

  return resultsMap.values.expand((element) => element).toList();
}

Future<List<TestResult>> runTestsUsingAllFlutterSdks(String module, String monarch_exe_) async {
  var stopwatch = Stopwatch()..start();
  var resultsMap = <String, List<TestResult>>{};

  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    var results = await runTest(flutter_exe(flutter_sdk), monarch_exe_, module);
    resultsMap[flutter_sdk] = [results];
  }

  printResults(resultsMap, stopwatch);

  return resultsMap.values.expand((element) => element).toList();
}

Future<List<TestResult>> runTestsOnAllModules(String flutter_exe_, String monarch_exe_) async {
  var stopwatch = Stopwatch()..start();
  var results = <TestResult>[];

  results.add(await runTest(flutter_exe_, monarch_exe_, 'cli'));
  results.add(await runTest(flutter_exe_, monarch_exe_, 'controller'));
  results.add(await runTest(flutter_exe_, monarch_exe_, 'packages/monarch'));
  results.add(await runTest(flutter_exe_, monarch_exe_, 'packages/monarch_io_utils'));
  results.add(await runTest(flutter_exe_, monarch_exe_, 'packages/monarch_utils'));
  results.add(await runTest(flutter_exe_, monarch_exe_, 'test/test_create'));
  results.add(await runTest(flutter_exe_, monarch_exe_, 'test/test_localizations'));
  results.add(await runTest(flutter_exe_, monarch_exe_, 'test/test_stories'));
  results.add(await runTest(flutter_exe_, monarch_exe_, 'test/test_themes'));

  printResults({flutter_exe_: results}, stopwatch);

  return results;
}

void printResults(
    Map<String, List<TestResult>> resultsMap, Stopwatch stopwatch) {
  print('''

### Test Results''');
  for (var key in resultsMap.keys) {
    print('');
    printUsingCommand(key);
    for (var result in resultsMap[key]!) {
      print('- $result');
    }
  }

  print('');
  print('Tests took ${stopwatch..stop()}.');
}

void printUsingCommand(String command) {
  if (command == 'dart' || command == 'flutter') {
    print('Using $command exe from PATH');
  } else {
    print('Using $command');
  }
}

Future<TestResult> runTest(
    String flutter_exe_, String monarch_exe_, String module) async {
  print('');
  print('### Running $module tests');

  var module_path = p.join(local_repo_paths.root, module);
  var command = dartOrFlutter(module_path, flutter_exe_);

  printUsingCommand(command);

  print('');
  print('Running `$command pub get` in $module...');
  var xpg = await Process.start(command, ['pub', 'get'],
      workingDirectory: module_path, runInShell: Platform.isWindows);
  stdout.addStream(xpg.stdout);
  stderr.addStream(xpg.stderr);
  await xpg.exitCode;

  print('');
  print('Running `$command test` in $module...');
  var process = await Process.start(command, ['test'],
      workingDirectory: module_path,
      runInShell: Platform.isWindows,
      environment: {
        'MONARCH_EXE': monarch_exe_,
        'FLUTTER_EXE': flutter_exe_,
      });

  if (module.startsWith('test')) {
    print('Integration tests environment variables:');
    print('  - MONARCH_EXE: $monarch_exe_');
    print('  - FLUTTER_EXE: $flutter_exe_');
  }

  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  var exitCode = await process.exitCode;
  var result = TestResult(module, exitCode);

  print('$module tests ${result.passed ? 'PASSED' : 'FAILED'}.');
  return result;
}

String dartOrFlutter(String module_path, String flutter_exe_) {
  var pubspecFile = File(p.join(module_path, 'pubspec.yaml'));
  if (!pubspecFile.existsSync()) {
    throw 'pubspec.yaml of $module_path does not exist';
  }
  if (pubspecFile.readAsStringSync().contains('sdk: flutter')) {
    return flutter_exe_;
  } else {
    return 'dart';
  }
}

class TestResult {
  final String module;
  final int exitCode;
  bool get passed => exitCode == 0;

  TestResult(this.module, this.exitCode);

  @override
  String toString() => '$module tests ${exitCode == 0 ? 'passed' : 'FAILED'}';
}
