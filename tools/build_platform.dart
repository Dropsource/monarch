import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';

import 'paths.dart';
import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;
import 'build_platform_args.dart' as build_platform_args;

/// Builds Monarch Platform binaries for each Flutter SDK
/// declared in local_settings.yaml.
void main() {
  print('''

### build_platform.dart
''');

  utils.createDirectoryIfNeeded(local_out_paths.out_ui);

  for (final flutter_sdk in local_utils.read_flutter_sdks()) {
    var out_ui_flutter_id_ =
        out_ui_flutter_id(local_out_paths.out_ui, flutter_sdk);
    utils.createDirectoryIfNeeded(out_ui_flutter_id_);

    build_platform_args
        .main([local_repo_paths.root, flutter_sdk, out_ui_flutter_id_]);
  }

  var version = functionForPlatform(
      macos: readMacosProjectVersion, windows: readWindowsProjectVersion);
  version = local_utils.getVersionSuffix(version);
  local_utils.writeInternalFile('platform_app_version.txt', version);
  print('Monarch ${os} platform build finished. Version $version');
}

String readMacosProjectVersion() {
  var result = Process.runSync('xcodebuild', ['-showBuildSettings'],
      workingDirectory: local_repo_paths.platform_macos);
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

String readWindowsProjectVersion() {
  var buildSettings =
      File(p.join(local_repo_paths.platform_windows, 'build_settings.yaml'))
          .readAsStringSync();
  var yaml = loadYaml(buildSettings) as YamlMap;
  return yaml['version'].toString();
}
