import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'paths.dart' as paths;

List<String> read_flutter_sdks() {
  var yaml = readLocalSettingsYaml();
  var key = 'local_flutter_sdks';
  if (!yaml.containsKey(key))
    throw 'Expected to find `$key` in ${paths.local_settings_yaml}';
  var sdks = yaml[key];
  if (!(sdks is YamlList))
    throw '`$key` in ${paths.local_settings_yaml} should be yaml list';
  if (sdks.isEmpty) throw '`$key` should not be empty';
  return sdks.nodes.map((sdk) => sdk.value.toString()).toList();
}

String read_deployment() {
  var yaml = readLocalSettingsYaml();
  var key = 'deployment';
  if (!yaml.containsKey(key)) return 'local';
  return yaml[key].toString();
}

String getVersionSuffix(String version) {
  var deployment = read_deployment();
  return deployment == 'prod' ? version : '$version-$deployment';
}

YamlMap readLocalSettingsYaml() {
  var file = File(p.join(paths.tools, paths.local_settings_yaml));
  if (!file.existsSync())
    throw 'Make sure you create ${paths.local_settings_yaml} inside the tools directory';
  var contents = file.readAsStringSync();
  return loadYaml(contents) as YamlMap;
}

void createDirectoryIfNeeded(String path) {
  var dir = Directory(path);
  if (!dir.existsSync()) dir.createSync(recursive: true);
}

String readPubspecVersion(String path) {
  var contents = File(path).readAsStringSync();
  var r = RegExp(r'^version: (\S+)$', multiLine: true);
  try {
    var version = r.firstMatch(contents)!.group(1)!;
    return version;
  } catch (e) {
    print('Error parsing version from pupspec.yaml');
    print(e);
    return 'unknown';
  }
}

void writeInternalFile(String name, String contents) {
  createDirectoryIfNeeded(paths.out_bin_internal);
  var file = File(p.join(paths.out_bin_internal, name));
  file.writeAsStringSync(contents, mode: FileMode.writeOnly);
}

void exitIfNeeded(ProcessResult result, String errorMessage) {
  if (result.exitCode != 0) {
    print(errorMessage);
    print(result.stdout);
    print(result.stderr);
    exit(1);
  }
}