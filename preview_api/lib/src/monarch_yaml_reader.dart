import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_utils/log.dart';

class MonarchYamlReader with Log {
  final String projectDirectoryPath;
  MonarchYamlReader(this.projectDirectoryPath);

  bool _hasYamlFile = false;
  bool get hasYamlFile => _hasYamlFile;

  String get monarchYamlPath => p.join(projectDirectoryPath, 'monarch.yaml');

  List<DeviceDefinition> devices = [];
  bool get hasDevices => hasYamlFile && devices.isNotEmpty;

  Future<void> read() async {
    final monarchYamlFile = File(monarchYamlPath);
    log.fine('Looking for monarch.yaml at $monarchYamlPath');
    if (!await monarchYamlFile.exists()) {
      log.fine('monarch.yaml not found');
      _hasYamlFile = false;
      return;
    }
    log.fine('monarch.yaml found');
    _hasYamlFile = true;

    try {
      final contents = await monarchYamlFile.readAsString();
      devices.addAll(getDevicesFromMonarchYaml(contents));
      log.fine('Found ${devices.length} devices in monarch.yaml');
    } catch (err, stack) {
      log.warning('Error processing monarch.yaml file', err, stack);
    }
  }

  static Iterable<DeviceDefinition> getDevicesFromMonarchYaml(
      String yamlContents) {
    final yaml = loadYaml(yamlContents);
    if (yaml['devices'] == null) {
      return [];
    }
    final devicesYaml = yaml['devices'] as List;

    return devicesYaml.map((device) => DeviceDefinition(
        id: device['id'],
        name: device['name'],
        logicalResolution: LogicalResolution(
            width: (device['width'] as num).toDouble(),
            height: (device['height'] as num).toDouble()),
        devicePixelRatio: (device['device_pixel_ratio'] as num).toDouble(),
        targetPlatform: targetPlatformFromString(device['platform'])));
  }
}
