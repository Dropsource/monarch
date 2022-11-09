import 'package:test/test.dart';
import 'package:monarch_cli/src/version_api/ui_bundle.dart';

final Map<String, dynamic> jsonUiBundle01 = {
  'timestamp': '2021-04-30 01:02:03.123456Z',
  'version_number': '0.4.0-7.0.dev',
  'operating_system': 'windows',
  'flutter_version': '2.0.5',
  'flutter_channel': 'stable',
  'ui_bundle_url':
      'https://dsnxlbv9ge72y.cloudfront.net/windows/0.4.0-7.0.dev/monarch_ui_0.4.0-7.0.dev_flutter_windows_2.0.5-stable.zip'
};

void main() {
  group('Version', () {
    test('fromJson', () {
      var version = UiBundle.fromJson(jsonUiBundle01);

      expect(
          version.timestamp, DateTime.utc(2021, 04, 30, 01, 02, 03, 0, 123456));
      expect(version.versionNumber, '0.4.0-7.0.dev');
      expect(version.operatingSystem, 'windows');
      expect(version.flutterVersion, '2.0.5');
      expect(version.flutterChannel, 'stable');

      expect(version.uiBundleUrl,
          'https://dsnxlbv9ge72y.cloudfront.net/windows/0.4.0-7.0.dev/monarch_ui_0.4.0-7.0.dev_flutter_windows_2.0.5-stable.zip');
    });

    test('key', () {
      var version = UiBundle(
          timestamp: DateTime.now(),
          versionNumber: '1.2.3',
          operatingSystem: 'windows',
          flutterVersion: '2.0.6',
          flutterChannel: 'stable',
          uiBundleUrl: 'foo/bar');

      expect(version.key, 'windows/1.2.3/flutter/2.0.6/stable');
    });
  });
}
