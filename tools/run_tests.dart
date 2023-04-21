import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:monarch_utils/timers.dart';

import 'paths.dart';

void main() async {
  var stopwatch = Stopwatch()..start();
  var results = <TestResult>[];
  print('''

### run_tests.dart''');

  {
    print('''

#### Running cli tests''');
    var process = await Process.start('dart', ['test'],
        workingDirectory: local_repo_paths.cli, runInShell: Platform.isWindows);
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
    var exitCode = await process.exitCode;
    results.add(TestResult('cli', exitCode));
  }

  {
    try {
      Process.runSync('flutter', ['--version'], runInShell: Platform.isWindows);
    } on ProcessException {
      print(
          'ERROR: Could not run flutter command. Make sure the flutter command is in your PATH.');
      exit(1);
    }
  }

  {
    print('''

#### Running controller tests''');
    var process = await Process.start('flutter', ['test'],
        workingDirectory: local_repo_paths.controller,
        runInShell: Platform.isWindows);
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
    var exitCode = await process.exitCode;
    results.add(TestResult('controller', exitCode));
  }

  results.add(await _runPackageTests('monarch', 'flutter'));
  results.add(await _runPackageTests('monarch_io_utils', 'dart'));
  results.add(await _runPackageTests('monarch_utils', 'dart'));

  results.add(await _runIntegrationTests('test_create'));
  results.add(await _runIntegrationTests('test_localizations'));
  results.add(await _runIntegrationTests('test_stories'));
  results.add(await _runIntegrationTests('test_themes'));

  print('''

#### Test Results''');
  for (var result in results) {
    print('- $result');
  }

  print('Tests took ${stopwatch..stop()}.');

  if (results.any((element) => element.exitCode != 0)) {
    exit(1);
  } else {
    exit(0);
  }
}

class TestResult {
  final String module;
  final int exitCode;
  TestResult(this.module, this.exitCode);
  @override
  String toString() => '$module tests ${exitCode == 0 ? 'passed' : 'FAILED'}';
}

Future<TestResult> _runPackageTests(String packageName, String command) async {
  print('''

#### Running $packageName package tests''');
  var process = await Process.start(command, ['test'],
      workingDirectory: p.join(local_repo_paths.packages, packageName),
      runInShell: Platform.isWindows);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  var exitCode = await process.exitCode;
  return TestResult('$packageName package', exitCode);
}

Future<TestResult> _runIntegrationTests(String testDirectory) async {
  print('''

#### Running $testDirectory integration tests''');
  // run integration tests with concurrency of 1
  var fpg = await Process.start('flutter', ['pub', 'get'],
      workingDirectory: p.join(local_repo_paths.test, testDirectory),
      runInShell: Platform.isWindows);
  stdout.addStream(fpg.stdout);
  stderr.addStream(fpg.stderr);
  await fpg.exitCode;

  var process = await Process.start('dart', ['test', '-j', '1'],
      workingDirectory: p.join(local_repo_paths.test, testDirectory),
      runInShell: Platform.isWindows);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  var exitCode = await process.exitCode;
  return TestResult(testDirectory, exitCode);
}
