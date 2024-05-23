import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:monarch_io_utils/monarch_io_utils.dart';

final localRoot = File(Platform.script.toFilePath()).parent.parent.path;
final os = valueForPlatform(macos: 'macos', windows: 'windows', linux: 'linux');

final local_repo_paths = RepoPaths(localRoot);
final local_out_paths = LocalOutPaths(p.join(localRoot, 'out'));

class RepoPaths {
  final String root;
  RepoPaths(this.root);

  String get cli => p.join(root, 'cli');
  String get controller => p.join(root, 'controller');
  String get preview_api => p.join(root, 'preview_api');
  String get packages => p.join(root, 'packages');
  String get platform => p.join(root, 'platform');
  String get tools => p.join(root, 'tools');
  String get test => p.join(root, 'test');

  String get platform_macos => p.join(platform, 'macos');
  String get platform_windows => p.join(platform, 'windows');
  String get platform_linux => p.join(platform, 'linux');

  String get platform_macos_ephemeral => p.join(platform_macos, 'ephemeral');

  String get platform_windows_gen_seed => p.join(platform_windows, 'gen_seed');
  String get platform_windows_gen => p.join(platform_windows, 'gen');
  String get platform_windows_build => p.join(platform_windows, 'build');
  String get platform_windows_src => p.join(platform_windows, 'src');

  String get platform_linux_gen_seed => p.join(platform_linux, 'gen_seed');
  String get platform_linux_gen => p.join(platform_linux, 'gen');
  String get platform_linux_build => p.join(platform_linux, 'build');
  String get platform_linux_src => p.join(platform_linux, 'src');
}

class LocalOutPaths {
  final String out;
  LocalOutPaths(this.out);

  String get out_monarch => p.join(out, 'monarch');
  String get out_bin => p.join(out_monarch, 'bin');
  String get out_bin_cache => p.join(out_bin, 'cache');
  String get out_ui => p.join(out_bin_cache, 'monarch_ui');
  String get out_bin_internal => p.join(out_bin, 'internal');

  String get out_bin_monarch_exe => p.join(out_bin, monarch_exe_file_name);
}

String flutter_id(String flutter_sdk) {
  var version = get_flutter_version(flutter_sdk);
  var channel = get_flutter_channel(flutter_sdk);
  return 'flutter_${os}_$version-$channel';
}

String out_ui_flutter_id(String out_ui, String flutter_sdk) =>
    p.join(out_ui, flutter_id(flutter_sdk));

String out_ui_flutter_id_monarch_macos_app(String flutter_id) =>
    p.join(flutter_id, 'monarch_macos.app');

String darwin_flutter_framework(String flutter_sdk) => p.join(flutter_sdk,
    'bin/cache/artifacts/engine/darwin-x64/FlutterMacOS.framework');

String darwin_flutter_xcframework(String flutter_sdk) => p.join(flutter_sdk,
    'bin/cache/artifacts/engine/darwin-x64/FlutterMacOS.xcframework/macos-arm64_x86_64/FlutterMacOS.framework');

String windows_flutter_windows_pdb(String flutter_sdk) => p.join(flutter_sdk,
    'bin\\cache\\artifacts\\engine\\windows-x64\\flutter_windows.dll.pdb');

String icudtl_dat(String flutter_sdk, String target_platform) => p.join(
    flutter_sdk,
    'bin',
    'cache',
    'artifacts',
    'engine',
    target_platform,
    'icudtl.dat');

String flutter_exe(String flutter_sdk) => p.join(flutter_sdk, 'bin', 'flutter');

String monarch_exe_file_name = valueForPlatform(
    macos: 'monarch', windows: 'monarch.exe', linux: 'monarch');

String monarch_exe(String monarch_dir) =>
    p.join(monarch_dir, 'bin', monarch_exe_file_name);

const local_settings_yaml = 'local_settings.yaml';

String get_flutter_version(String flutter_sdk) {
  var version = File(p.join(flutter_sdk, 'version')).readAsStringSync();
  return version;
}

String get_flutter_channel(String flutter_sdk) {
  var result = Process.runSync('git', ['branch', '--show-current'],
      workingDirectory: flutter_sdk);
  if (result.exitCode != 0) {
    print('Error reading flutter channel');
    print(result.stdout);
    print(result.stderr);
  }
  var channel = result.stdout.trim();
  if (channel == 'stable' || channel == 'beta' || channel == 'master') {
    return channel;
  } else {
    return 'unknown';
  }
}

String gen_seed_flutter_id(String platform_gen_seed, String flutter_sdk) =>
    p.join(platform_gen_seed, flutter_id(flutter_sdk));

String build_flutter_id(String build, String flutter_sdk) =>
    p.join(build, flutter_id(flutter_sdk));

String get_dart_version(String flutter_sdk) {
  var version = File(p.join(flutter_sdk, 'bin', 'cache', 'dart-sdk', 'version'))
      .readAsStringSync();
  return version.trim();
}
