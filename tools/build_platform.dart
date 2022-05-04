import 'dart:io';
import 'package:path/path.dart' as p;

import 'paths.dart' as paths;
import 'utils.dart' as utils;

void main() {
  print('''

### build_platform.dart
''');

  utils.createDirectoryIfNeeded(paths.out_ui);

  for (final flutter_sdk in utils.read_flutter_sdks()) {
    print('''
===============================================================================
Using flutter sdk at:
  $flutter_sdk
''');

    var out_ui_flutter_id = paths.compute_out_ui_flutter_id(flutter_sdk);
    utils.createDirectoryIfNeeded(out_ui_flutter_id);

    if (Platform.isMacOS) {
      const monarch_macos = 'monarch_macos';

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

      var monarch_macos_app_dir = Directory(
          paths.out_ui_flutter_id_monarch_macos_app(out_ui_flutter_id));
      if (monarch_macos_app_dir.existsSync())
        monarch_macos_app_dir.deleteSync(recursive: true);

      print('''
Building $monarch_macos with xcodebuild. Will output to:
  ${paths.out_ui_flutter_id_monarch_macos_app(out_ui_flutter_id)}
''');

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

  if (Platform.isMacOS) {
    var version = readMacosProjectVersion();
    version = utils.getVersionSuffix(version);
    utils.writeInternalFile('platform_app_version.txt', version);
    print('Monarch macos platform build finished. Version $version');
  }

}

String readMacosProjectVersion() {
  var result = Process.runSync('xcodebuild', ['-showBuildSettings'],
      workingDirectory: paths.platform_macos);
  if (result.exitCode != 0) {
    print('Error running xcodebuild -showBuildSettings');
    print(result.stdout);
    print(result.stderr);
    return 'unknown';
  }
  var contents = result.stdout.toString();
  var r = RegExp(r'^\s*MARKETING_VERSION = (\S+)$', multiLine: true);
  try {
    var version = r.firstMatch(contents)!.group(1)!;
    return version;
  } catch (e) {
    print('Error parsing version from xcode build setings');
    print(e);
    return 'unknown';
  }
}
