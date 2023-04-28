import 'dart:io';

import 'package:args/args.dart';
import 'package:monarch_utils/timers.dart';
import 'utils_local.dart' as local_utils;
import 'package:path/path.dart' as p;
import 'paths.dart';

void main(List<String> arguments) async {
  var parser = ArgParser();

  parser.addOption('flutter_exe',
      abbr: 'f',
      help:
          'Path to the flutter exe. Defaults to the flutter exe sourced in your PATH.');
  parser.addOption('module',
      abbr: 'm',
      help:
          'The relative path to the monarch module to test; such as: cli, package/monarch, test/test_create, etc. '
          'By default, it will test all modules.');
  parser.addFlag('help', abbr: 'h');
  parser.addFlag('all',
      help:
          'Where to test using all the flutter sdks listed in local_settings.yaml.');

  var args = parser.parse(arguments);

  if (args['help']) {
    print(parser.usage);
    exit(0);
  }

  if (args['all']) {
    if (args['module'] == null) {
      var results = await runTestsUsingAllFlutterSdksOnAllModules();
      exit_(results);
    } else {
      var results =
          await runTestsUsingAllFlutterSdks(args['module'].toString());
      exit_(results);
    }
  }

  String flutter_exe_ = args['flutter_exe'] ?? 'flutter';

  if (args['module'] == null) {
    var results = await runTestsOnAllModules(flutter_exe_);
    exit_(results);
  }

  String module = args['module'].toString();

  var result = await runTest(flutter_exe_, module);
  result.passed ? exit(0) : exit(1);
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

Future<List<TestResult>> runTestsUsingAllFlutterSdksOnAllModules() async {
  var stopwatch = Stopwatch()..start();
  var resultsMap = <String, List<TestResult>>{};

  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    var results = await runTestsOnAllModules(flutter_exe(flutter_sdk));
    resultsMap[flutter_sdk] = results;
  }

  printResults(resultsMap, stopwatch);

  return resultsMap.values.expand((element) => element).toList();
}

Future<List<TestResult>> runTestsUsingAllFlutterSdks(String module) async {
  var stopwatch = Stopwatch()..start();
  var resultsMap = <String, List<TestResult>>{};

  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    var results = await runTest(flutter_exe(flutter_sdk), module);
    resultsMap[flutter_sdk] = [results];
  }

  printResults(resultsMap, stopwatch);

  return resultsMap.values.expand((element) => element).toList();
}

Future<List<TestResult>> runTestsOnAllModules(String flutter_exe_) async {
  var stopwatch = Stopwatch()..start();
  var results = <TestResult>[];

  results.add(await runTest(flutter_exe_, 'cli'));
  results.add(await runTest(flutter_exe_, 'controller'));
  results.add(await runTest(flutter_exe_, 'packages/monarch'));
  results.add(await runTest(flutter_exe_, 'packages/monarch_io_utils'));
  results.add(await runTest(flutter_exe_, 'packages/monarch_utils'));
  results.add(await runTest(flutter_exe_, 'test/test_create'));
  results.add(await runTest(flutter_exe_, 'test/test_localizations'));
  results.add(await runTest(flutter_exe_, 'test/test_stories'));
  results.add(await runTest(flutter_exe_, 'test/test_themes'));

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

Future<TestResult> runTest(String flutter_exe_, String module) async {
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
  var monarch_exe_ = local_out_paths.out_bin_monarch_exe;
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
