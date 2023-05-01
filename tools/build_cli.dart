import 'dart:io';

import 'paths.dart';
import 'utils.dart' as utils;

void buildCli() {
  print('''

### build_cli.dart
''');

  {
    utils.createDirectoryIfNeeded(local_out_paths.out_bin);
    var monarch_exe_file = File(local_out_paths.out_bin_monarch_exe);
    if (monarch_exe_file.existsSync()) monarch_exe_file.deleteSync();
  }

  {
    var result = Process.runSync('dart', ['--version']);
    utils.exitIfNeeded(result, 'Error getting dart version');
    print('Using ${result.stdout.trim()}');
  }

  {
    print('''
Running `dart pub get` in:
  ${local_repo_paths.cli}
''');
    var result = Process.runSync('dart', ['pub', 'get'],
        workingDirectory: local_repo_paths.cli);
    utils.exitIfNeeded(result, 'Error running `dart pub get`');
  }

  {
    print('''
Building monarch_cli executable. Will output to:
  ${local_out_paths.out_bin_monarch_exe}
''');

    var result = Process.runSync(
        'dart',
        [
          'compile',
          'exe',
          'bin/main.dart',
          '-o',
          local_out_paths.out_bin_monarch_exe
        ],
        workingDirectory: local_repo_paths.cli);
    utils.exitIfNeeded(result, 'Error building monarch cli');
  }

  print('Monarch CLI build finished.');
}
