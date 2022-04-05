import 'dart:io';
import 'package:path/path.dart' as p;

import 'paths.dart' as paths;

void main() {
  var uiDir = Directory(paths.out_ui);
  if (uiDir.existsSync()) uiDir.deleteSync(recursive: true);
  uiDir.createSync(recursive: true);

  for (final flutterSdkPath in paths.flutter_sdks()) {
    print('''
===============================================================================
Using flutter sdk at:
  $flutterSdkPath
''');

    var version = File(p.join(flutterSdkPath, 'version')).readAsStringSync();
    print('Flutter version is $version');

    var result = Process.runSync('git', ['branch', '--show-current'],
        workingDirectory: flutterSdkPath);
    if (result.exitCode != 0) {
      print('Error reading flutter channel');
      print(result.stdout);
      print(result.stderr);
    }
    var channel = result.stdout.trim();
    print('Flutter channel is $channel');

    var flutterIdPath = paths.out_ui_flutter_id(version, channel);
    print('''
Will output monarch ${paths.os} binaries to:
  $flutterIdPath
''');

    if (Platform.isMacOS) {
      var ephemeralDir = Directory(paths.platform_macos_ephemeral);
      if (ephemeralDir.existsSync()) ephemeralDir.deleteSync(recursive: true);
      ephemeralDir.createSync(recursive: true);

      print('Copying darwin flutter framework bundle to ephemeral directory...');

      var result = Process.runSync('cp', [
        '-R',
        paths.darwin_flutter_framework(flutterSdkPath),
        paths.platform_macos_ephemeral
      ]);
      if (result.exitCode != 0) {
        print('Error copying darwin flutter framework bundle');
        print(result.stdout);
        print(result.stderr);
      }

      var macosAppDir =
          Directory(paths.out_ui_flutter_id_monarch_macos_app(flutterIdPath));
      if (macosAppDir.existsSync())
        macosAppDir.deleteSync(recursive: true);

      print('Building monarch_macos with xcodebuild...');

      result = Process.runSync('xcodebuild', [
        '-scheme',
        'monarch_macos',
        'CONFIGURATION_BUILD_DIR=$flutterIdPath',
        'build'
      ], workingDirectory: paths.platform_macos);
      if (result.exitCode != 0) {
        print('Error running xcodebuild');
        print(result.stdout);
        print(result.stderr);
      }

      Directory(p.join(flutterIdPath, 'monarch_macos.swiftmodule'))
          .deleteSync(recursive: true);
    }
    print('''
===============================================================================
''');
  }

  print('Monarch platform build finished.');
}
