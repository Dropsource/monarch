import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'test_result.dart';
import 'paths.dart';

void main(List<String> arguments) async {
  var parser = ArgParser();

  parser.addOption('flutter_exe',
      abbr: 'f',
      help:
          'Path to the flutter exe. Leave blank to use the flutter exe sourced in your PATH.');
  parser.addOption('module',
      abbr: 'm',
      help:
          'The relative path to the monarch module to test; such as: cli, package/monarch, test/test_create, etc.',
      defaultsTo: 'cli');
  parser.addFlag('help', abbr: 'h');

  var results = parser.parse(arguments);

  if (results['help']) {
    print(parser.usage);
    exit(0);
  }

  String module = results['module'].toString();
  String flutter = results['flutter_exe'] ?? 'flutter';

  var result = await runTest(flutter, module);
  result.passed ? exit(0) : exit(1);
}

Future<TestResult> runTest(String flutter_exe_, String module) async {
  print('### Running $module tests');

  var module_path = p.join(local_repo_paths.root, module);
  var command = dartOrFlutter(module_path, flutter_exe_);

  if (command == 'dart' || command == 'flutter') {
    print('Using $command exe from PATH');
  }
  else {
    print('Using $command');
  }

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
