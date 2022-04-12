import 'dart:io';
import 'package:monarch_io_utils/utils.dart';
import 'package:path/path.dart' as p;

import 'paths.dart' as paths;

void main() {
    print('''

### build_controller.dart
''');

  paths.createDirectoryIfNeeded(paths.out_ui);

  for (final flutter_sdk in paths.read_flutter_sdks()) {
    print('''
===============================================================================
Using flutter sdk at:
  $flutter_sdk
''');

    var out_ui_flutter_id = paths.compute_out_ui_flutter_id(flutter_sdk);
    paths.createDirectoryIfNeeded(out_ui_flutter_id);

    var out_ui_flutter_id_controller =
        paths.out_ui_flutter_id_controller(out_ui_flutter_id);
    var out_controller_dir = Directory(out_ui_flutter_id_controller);
    if (out_controller_dir.existsSync()) out_controller_dir.deleteSync(recursive: true);
    out_controller_dir.createSync(recursive: true);

    print('Building monarch controller flutter bundle...');

    var result = Process.runSync(
        paths.flutter_exe(flutter_sdk),
        [
          'build',
          'bundle',
          '-t',
          'lib/main.dart',
          '--debug',
          '--target-platform',
          valueForPlatform(macos: 'darwin', windows: 'windows-x64'),
          '--asset-dir',
          p.join(out_ui_flutter_id_controller, 'flutter_assets'),
          '--verbose'
        ],
        workingDirectory: paths.controller);

    if (result.exitCode != 0) {
        print('Error building monarch controller flutter bundle');
        print(result.stdout);
        print(result.stderr);
      }

    print('''
===============================================================================
''');
  }

  print('Monarch controller build finished.');
}
