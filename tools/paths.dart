import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:monarch_io_utils/utils.dart';
import 'package:yaml/yaml.dart';

final root = File(Platform.script.toFilePath()).parent.parent.path;

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

final out_bin = p.join(out, 'monarch', 'bin');
final out_bin_cache = p.join(out_bin, 'cache');
final out_ui = p.join(out_bin_cache, 'monarch_ui');

String out_ui_flutter_id(String version, String channel) =>
    p.join(out_ui, 'flutter_${os}_$version-$channel');

String out_ui_flutter_id_monarch_macos_app(String flutter_id) =>
    p.join(flutter_id, 'monarch_macos.app');

String out_ui_flutter_id_controller(String flutter_id) =>
    p.join(flutter_id, 'monarch_controller');

String darwin_flutter_framework(String flutter_sdk) => p.join(flutter_sdk,
    'bin/cache/artifacts/engine/darwin-x64/FlutterMacOS.framework');

String flutter_exe(String flutter_sdk) => p.join(flutter_sdk, 'bin', 'flutter');

final os = valueForPlatform(macos: 'macos', windows: 'windows', linux: 'linux');

const local_settings_yaml = 'local_settings.yaml';

List<String> read_flutter_sdks() {
  var yaml = readLocalSettingsYaml();
  var key = 'local_flutter_sdks';
  if (!yaml.containsKey(key))
    throw 'Expected to find `$key` in $local_settings_yaml';
  var sdks = yaml[key];
  if (!(sdks is YamlList))
    throw '`$key` in $local_settings_yaml should be yaml list';
  if (sdks.isEmpty) throw '`$key` should not be empty';
  return sdks.nodes.map((sdk) => sdk.value.toString()).toList();
}

YamlMap readLocalSettingsYaml() {
  var file = File(p.join(tools, local_settings_yaml));
  if (!file.existsSync())
    throw 'Make sure you create $local_settings_yaml inside the tools directory';
  var contents = file.readAsStringSync();
  return loadYaml(contents) as YamlMap;
}

void createDirectoryIfNeeded(String path) {
  var dir = Directory(path);
  if (!dir.existsSync()) dir.createSync(recursive: true);
}

String compute_out_ui_flutter_id(String flutter_sdk) {
  var version = File(p.join(flutter_sdk, 'version')).readAsStringSync();
  print('Flutter version is $version');

  var result = Process.runSync('git', ['branch', '--show-current'],
      workingDirectory: flutter_sdk);
  if (result.exitCode != 0) {
    print('Error reading flutter channel');
    print(result.stdout);
    print(result.stderr);
  }
  var channel = result.stdout.trim();
  print('Flutter channel is $channel');

  return out_ui_flutter_id(version, channel);
}
