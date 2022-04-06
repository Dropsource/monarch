import 'dart:io';
import 'package:path/path.dart' as p;

import 'paths.dart' as paths;

void main() {
  paths.createDirectoryIfNeeded(paths.out_ui);

  for (final flutter_sdk in paths.read_flutter_sdks()) {
    print('''
===============================================================================
Using flutter sdk at:
  $flutter_sdk
''');

    var out_ui_flutter_id = paths.compute_out_ui_flutter_id(flutter_sdk);
    paths.createDirectoryIfNeeded(out_ui_flutter_id);

    if (Platform.isMacOS) {
      const monarch_macos = 'monarch_macos';
      print('''
Will output $monarch_macos to:
  $out_ui_flutter_id
''');

      var ephemeral_dir = Directory(paths.platform_macos_ephemeral);
      if (ephemeral_dir.existsSync()) ephemeral_dir.deleteSync(recursive: true);
      ephemeral_dir.createSync(recursive: true);

      print(
          'Copying darwin flutter framework bundle to ephemeral directory...');

      var result = Process.runSync('cp', [
        '-R',
        paths.darwin_flutter_framework(flutter_sdk),
        paths.platform_macos_ephemeral
      ]);
      if (result.exitCode != 0) {
        print('Error copying darwin flutter framework bundle');
        print(result.stdout);
        print(result.stderr);
      }

      var monarch_macos_app_dir =
          Directory(paths.out_ui_flutter_id_monarch_macos_app(out_ui_flutter_id));
      if (monarch_macos_app_dir.existsSync())
        monarch_macos_app_dir.deleteSync(recursive: true);

      print('Building $monarch_macos with xcodebuild...');

      result = Process.runSync(
          'xcodebuild',
          [
            '-scheme',
            '$monarch_macos',
            'CONFIGURATION_BUILD_DIR=$out_ui_flutter_id',
            'build'
          ],
          workingDirectory: paths.platform_macos);
      if (result.exitCode != 0) {
        print('Error running xcodebuild');
        print(result.stdout);
        print(result.stderr);
      }

      Directory(p.join(out_ui_flutter_id, '$monarch_macos.swiftmodule'))
          .deleteSync(recursive: true);
    }
    print('''
===============================================================================
''');
  }

  print('Monarch platform build finished.');
}
