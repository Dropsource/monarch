import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:monarch_io_utils/utils.dart';

final root = File(Platform.script.toFilePath()).parent.parent.path;
final os = valueForPlatform(macos: 'macos', windows: 'windows', linux: 'linux');

final cli = p.join(root, 'cli');
final controller = p.join(root, 'controller');
final out = p.join(root, 'out');
final packages = p.join(root, 'packages');
final platform = p.join(root, 'platform');
final tools = p.join(root, 'tools');

final platform_linux = p.join(platform, 'linux');
final platform_macos = p.join(platform, 'macos');
final platform_windows = p.join(platform, 'windows');

final platform_macos_ephemeral = p.join(platform_macos, 'ephemeral');

final platform_windows_gen_seed = p.join(platform_windows, 'gen_seed');
final platform_windows_gen = p.join(platform_windows, 'gen');
final platform_windows_build = p.join(platform_windows, 'build');
final platform_windows_src = p.join(platform_windows, 'src');

final out_bin = p.join(out, 'monarch', 'bin');
final out_bin_cache = p.join(out_bin, 'cache');
final out_ui = p.join(out_bin_cache, 'monarch_ui');
final out_bin_internal = p.join(out_bin, 'internal');

final out_bin_monarch_exe =
    p.join(out_bin, valueForPlatform(macos: 'monarch', windows: 'monarch.exe'));

String flutter_id(String flutter_sdk) {
  var version = get_flutter_version(flutter_sdk);
  var channel = get_flutter_channel(flutter_sdk);
  return 'flutter_${os}_$version-$channel';
}

String out_ui_flutter_id(String flutter_sdk) =>
    p.join(out_ui, flutter_id(flutter_sdk));

String out_ui_flutter_id_monarch_macos_app(String flutter_id) =>
    p.join(flutter_id, 'monarch_macos.app');

String out_ui_flutter_id_controller(String flutter_id) =>
    p.join(flutter_id, 'monarch_controller');

String darwin_flutter_framework(String flutter_sdk) => p.join(flutter_sdk,
    'bin/cache/artifacts/engine/darwin-x64/FlutterMacOS.framework');

String flutter_exe(String flutter_sdk) => p.join(flutter_sdk, 'bin', 'flutter');

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
  return channel;
}

String gen_seed_flutter_id(String platform_gen_seed, String flutter_sdk) =>
    p.join(platform_gen_seed, flutter_id(flutter_sdk));

String build_flutter_id(String build, String flutter_sdk) =>
    p.join(build, flutter_id(flutter_sdk));
