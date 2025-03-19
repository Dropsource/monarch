import 'package:flutter_test/flutter_test.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:preview_api/src/monarch_yaml_reader.dart';

void main() {
  group('getDevicesFromMonarchYaml', () {
    test('should parse devices from valid yaml', () {
      final yamlContents = '''
      devices:
        - id: device1
          name: Device One
          width: 1080
          height: 1920
          device_pixel_ratio: 2.0
          platform: android
        - id: device2
          name: Device Two
          width: 750
          height: 1334
          device_pixel_ratio: 2.0
          platform: ios
      ''';

      final devices =
          MonarchYamlReader.getDevicesFromMonarchYaml(yamlContents).toList();

      expect(devices.length, 2);
      expect(devices[0].id, 'device1');
      expect(devices[0].name, 'Device One');
      expect(devices[0].logicalResolution.width, 1080);
      expect(devices[0].logicalResolution.height, 1920);
      expect(devices[0].devicePixelRatio, 2.0);
      expect(devices[0].targetPlatform, MonarchTargetPlatform.android);

      expect(devices[1].id, 'device2');
      expect(devices[1].name, 'Device Two');
      expect(devices[1].logicalResolution.width, 750);
      expect(devices[1].logicalResolution.height, 1334);
      expect(devices[1].devicePixelRatio, 2.0);
      expect(devices[1].targetPlatform, MonarchTargetPlatform.iOS);
    });

    test('should return empty list for yaml without devices', () {
      final yamlContents = '''
      foo: bar
      ''';

      final devices =
          MonarchYamlReader.getDevicesFromMonarchYaml(yamlContents).toList();

      expect(devices.isEmpty, true);
    });

    test('should return empty list for empty yaml devices', () {
      final yamlContents = '''
      devices: 
      ''';

      final devices =
          MonarchYamlReader.getDevicesFromMonarchYaml(yamlContents).toList();

      expect(devices.isEmpty, true);
    });
  });
}
