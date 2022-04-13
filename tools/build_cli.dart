import 'dart:io';
import 'package:path/path.dart' as p;

import 'paths.dart' as paths;
import 'utils.dart' as utils;

void main() {
  print('''

### build_cli.dart
''');

  utils.createDirectoryIfNeeded(paths.out_bin);
  var monarch_exe_file = File(paths.out_bin_monarch_exe);
  if (monarch_exe_file.existsSync()) monarch_exe_file.deleteSync();

  var result = Process.runSync('dart', ['--version']);
  if (result.exitCode != 0) {
    print('Error getting dart version');
    print(result.stdout);
    print(result.stderr);
  }
  print('Using ${result.stdout.trim()}');

  print('Building monarch cli...');

  result = Process.runSync('dart',
      ['compile', 'exe', 'bin/main.dart', '-o', paths.out_bin_monarch_exe],
      workingDirectory: paths.cli);
  if (result.exitCode != 0) {
    print('Error building monarch cli');
    print(result.stdout);
    print(result.stderr);
  }

  var version =
      utils.readPubspecVersion(p.join(paths.cli, 'pubspec.yaml'));
  version = utils.getVersionSuffix(version);

  utils.writeInternalFile('cli_version.txt', version);

  print('Monarch CLI build finished. Version $version');
}
