import 'dart:io';
import 'package:path/path.dart' as p;

import 'paths.dart';

void main() async {
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

  {
    print('''

#### Running integration tests''');
    var process = await Process.start('dart', ['test', '.'],
        workingDirectory: local_repo_paths.test,
        runInShell: Platform.isWindows);
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
    var exitCode = await process.exitCode;
    results.add(TestResult('integration', exitCode));
  }

  print('''

#### Test Results''');
  for (var result in results) {
    print('- $result');
  }
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
