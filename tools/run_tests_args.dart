import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:monarch_utils/timers.dart';

import 'paths.dart';

/// Runs Monarch tests with these arguments:
/// - Path to the flutter exe
/// - Path to the monarch exe
///
/// This script is used by local builds and by the monarch automation.
Future<void> main(List<String> arguments) async {
  var flutter_exe_ = arguments[0];
  var monarch_exe_ = arguments[1];

  var results = await runTests(flutter_exe_, monarch_exe_);

  if (results.any((result) => !result.passed)) {
    exit(1);
  }
  else {
    exit(0);
  }
}

Future<List<TestResult>> runTests(String flutter_exe_, String monarch_exe_) async {

  var stopwatch = Stopwatch()..start();
  var results = <TestResult>[];

  var testArgumentsPrint = '''
### Test arguments
- Flutter exe:
  $flutter_exe_
- Monarch exe:
  $monarch_exe_''';

  print('''
===============================================================================
$testArgumentsPrint''');

  {
    print('''

### Running cli tests''');
    var process = await Process.start('dart', ['test'],
        workingDirectory: local_repo_paths.cli, runInShell: Platform.isWindows);
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
    var exitCode = await process.exitCode;
    results.add(TestResult('cli', exitCode));
  }

  {
    try {
      Process.runSync(flutter_exe_, ['--version'],
          runInShell: Platform.isWindows);
    } on ProcessException {
      print(
          'ERROR: Could not run flutter command. Make sure the flutter command is in your PATH.');
      exit(1);
    }
  }

  {
    print('''

### Running controller tests''');
    var fpg = await Process.start(flutter_exe_, ['pub', 'get'],
        workingDirectory: local_repo_paths.controller,
        runInShell: Platform.isWindows);
    stdout.addStream(fpg.stdout);
    stderr.addStream(fpg.stderr);
    await fpg.exitCode;

    var process = await Process.start(flutter_exe_, ['test'],
        workingDirectory: local_repo_paths.controller,
        runInShell: Platform.isWindows);
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
    var exitCode = await process.exitCode;
    results.add(TestResult('controller', exitCode));
  }
  {
    Future<TestResult> runPackageTests(
        String packageName, String command) async {
      print('''

### Running $packageName package tests''');
      var xpg = await Process.start(command, ['pub', 'get'],
          workingDirectory: local_repo_paths.controller,
          runInShell: Platform.isWindows);
      stdout.addStream(xpg.stdout);
      stderr.addStream(xpg.stderr);
      await xpg.exitCode;

      var process = await Process.start(command, ['test'],
          workingDirectory: p.join(local_repo_paths.packages, packageName),
          runInShell: Platform.isWindows);
      stdout.addStream(process.stdout);
      stderr.addStream(process.stderr);
      var exitCode = await process.exitCode;
      return TestResult('$packageName package', exitCode);
    }

    results.add(await runPackageTests('monarch', flutter_exe_));
    results.add(await runPackageTests('monarch_io_utils', 'dart'));
    results.add(await runPackageTests('monarch_utils', 'dart'));
  }

  {
    Future<TestResult> runIntegrationTests(String testDirectory) async {
      print('''

### Running $testDirectory integration tests''');
      // run integration tests with concurrency of 1
      var fpg = await Process.start(flutter_exe_, ['pub', 'get'],
          workingDirectory: p.join(local_repo_paths.test, testDirectory),
          runInShell: Platform.isWindows);
      stdout.addStream(fpg.stdout);
      stderr.addStream(fpg.stderr);
      await fpg.exitCode;

      var process = await Process.start(flutter_exe_, ['test', '-j', '1'],
          workingDirectory: p.join(local_repo_paths.test, testDirectory),
          runInShell: Platform.isWindows,
          environment: {
            'MONARCH_EXE': monarch_exe_,
            'FLUTTER_EXE': flutter_exe_,
          });

      stdout.addStream(process.stdout);
      stderr.addStream(process.stderr);
      var exitCode = await process.exitCode;
      return TestResult(testDirectory, exitCode);
    }

    results.add(await runIntegrationTests('test_create'));
    results.add(await runIntegrationTests('test_localizations'));
    results.add(await runIntegrationTests('test_stories'));
    results.add(await runIntegrationTests('test_themes'));
  }

  print('\n$testArgumentsPrint');

  print('''

### Test Results''');
  for (var result in results) {
    print('- $result');
  }

  print('Tests took ${stopwatch..stop()}.');

  print('''
===============================================================================
''');

  return results;
}

class TestResult {
  final String module;
  final int exitCode;
  bool get passed => exitCode == 0;

  TestResult(this.module, this.exitCode);
  
  @override
  String toString() => '$module tests ${exitCode == 0 ? 'passed' : 'FAILED'}';
}
