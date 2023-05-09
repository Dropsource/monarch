import 'dart:io';

import 'package:path/path.dart' as p;
import 'paths.dart';
import 'utils.dart' as utils;

void buildCli(String out_monarch_bin) {
  print('''

### build_cli.dart
''');

  var monarch_exe_file = File(p.join(out_monarch_bin, monarch_exe_file_name));

  {
    utils.createDirectoryIfNeeded(out_monarch_bin);
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
  ${monarch_exe_file.path}
''');

    var result = Process.runSync(
        'dart',
        [
          'compile',
          'exe',
          'bin/main.dart',
          '-o',
          monarch_exe_file.path
        ],
        workingDirectory: local_repo_paths.cli);
    utils.exitIfNeeded(result, 'Error building monarch cli');
  }

  print('Monarch CLI build finished.');
}
