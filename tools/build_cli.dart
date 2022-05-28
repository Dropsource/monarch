import 'dart:io';
import 'package:path/path.dart' as p;

import 'paths.dart' as paths;
import 'utils.dart' as utils;

void main() {
  print('''

### build_cli.dart
''');

  {
    utils.createDirectoryIfNeeded(paths.out_bin);
    var monarch_exe_file = File(paths.out_bin_monarch_exe);
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
  ${paths.cli}
''');
    var result =
        Process.runSync('dart', ['pub', 'get'], workingDirectory: paths.cli);
    utils.exitIfNeeded(result, 'Error running `dart pub get`');
  }

  {
    print('''
Building monarch_cli executable. Will output to:
  ${paths.out_bin_monarch_exe}
''');

    var result = Process.runSync('dart',
        ['compile', 'exe', 'bin/main.dart', '-o', paths.out_bin_monarch_exe],
        workingDirectory: paths.cli);
    utils.exitIfNeeded(result, 'Error building monarch cli');
  }

  {
    var version = utils.readPubspecVersion(p.join(paths.cli, 'pubspec.yaml'));
    version = utils.getVersionSuffix(version);
    utils.writeInternalFile('cli_version.txt', version);
    print('Monarch CLI build finished. Version $version');
  }
}
