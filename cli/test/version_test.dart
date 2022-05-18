import 'package:test/test.dart';
import 'package:monarch_cli/src/version_api/version.dart';

final Map<String, dynamic> jsonVersion01 = {
  'timestamp': '2021-04-30 01:02:03.123456Z',
  'version_number': '0.3.11',
  'operating_system': 'macos',
  'affects_operating_system': true,
  'installation_bundle_url':
      'https://dyymmqcqox4dd.cloudfront.net/macos/monarch_macos_0.3.11.zip',
  'version_tag': 'v0.3.11',
  'revision': 'abcdefghi',
  'min_flutter_version': '2.4.0-pre.1',
  'is_released': true,
  'cli_version_tag': null,
  'desktop_app_version_tag': null
};

void main() {
  group('Version', () {
    test('fromJson', () {
      var version = Version.fromJson(jsonVersion01);

      expect(
          version.timestamp, DateTime.utc(2021, 04, 30, 01, 02, 03, 0, 123456));
      expect(version.versionNumber, '0.3.11');
      expect(version.operatingSystem, 'macos');
      expect(version.affectsOperatingSystem, true);
      expect(version.installationBundleUrl,
          'https://dyymmqcqox4dd.cloudfront.net/macos/monarch_macos_0.3.11.zip');
      expect(version.versionTag, 'v0.3.11');
      expect(version.revision, 'abcdefghi');
      expect(version.minFlutterVersion, '2.4.0-pre.1');
      expect(version.isReleased, isTrue);
    });

    test('key', () {
      var version = Version(
          timestamp: DateTime.now(),
          versionNumber: '1.2.3',
          operatingSystem: 'macos',
          affectsOperatingSystem: true,
          installationBundleUrl: 'foo/bar',
          versionTag: 'v1.2.3',
          revision: 'mnopqr',
          minFlutterVersion: '2.4.0',
          isReleased: true);

      expect(version.key, 'macos/1.2.3');
    });
  });
}
