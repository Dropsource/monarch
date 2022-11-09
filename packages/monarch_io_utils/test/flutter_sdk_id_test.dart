import 'package:test/test.dart';
import 'package:monarch_io_utils/src/flutter_sdk_id.dart';

void main() {
  group('FlutterSdkId', () {
    test('toString', () {
      expect(
          FlutterSdkId(
                  channel: 'stable', version: '2.0.5', operatingSystem: 'macos')
              .toString(),
          'flutter_macos_2.0.5-stable');
      expect(
          FlutterSdkId(
                  channel: 'dev',
                  version: '2.2.0-10.1.pre',
                  operatingSystem: 'windows')
              .toString(),
          'flutter_windows_2.2.0-10.1.pre-dev');
    });

    test('equals', () {
      var id01 = FlutterSdkId(
          channel: 'stable', version: '2.0.5', operatingSystem: 'macos');
      var id02 = FlutterSdkId(
          channel: 'stable', version: '2.0.5', operatingSystem: 'macos');
      expect(id01 == id02, isTrue);
      expect(id01.hashCode == id02.hashCode, isTrue);
    });

    test('not equals', () {
      var id01 = FlutterSdkId(
          channel: 'stable', version: '2.0.5', operatingSystem: 'windows');
      var id02 = FlutterSdkId(
          channel: 'stable', version: '2.0.5', operatingSystem: 'macos');
      expect(id01 == id02, isFalse);
      expect(id01.hashCode == id02.hashCode, isFalse);
    });

    test('parse', () {
      {
        var id = FlutterSdkId.parse('flutter_macos_2.0.5-stable');
        expect(id.version, '2.0.5');
        expect(id.channel, 'stable');
        expect(id.operatingSystem, 'macos');
      }
      {
        var id = FlutterSdkId.parse('flutter_windows_2.2.0-10.1.pre-dev');
        expect(id.version, '2.2.0-10.1.pre');
        expect(id.channel, 'dev');
        expect(id.operatingSystem, 'windows');
      }
      {
        var id = FlutterSdkId.parse('flutter_linux_2.2.333-a+b.pre-beta');
        expect(id.version, '2.2.333-a+b.pre');
        expect(id.channel, 'beta');
        expect(id.operatingSystem, 'linux');
      }
      {
        var id = FlutterSdkId.parse('flutter_macos_2.2.0-unknown');
        expect(id.version, '2.2.0');
        expect(id.channel, 'unknown');
        expect(id.operatingSystem, 'macos');
      }
    });

    test('parse throws', () {
      expect(() => FlutterSdkId.parse('flutter_macos_'), throwsArgumentError);
    });
    test('parseFlutterVersionOutput', () {
      {
        var id = FlutterSdkId.parseFlutterVersionOutput('''
Flutter 2.0.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 1d9032c7e1 (4 days ago) • 2021-04-29 17:37:58 -0700
Engine • revision 05e680e202
Tools • Dart 2.12.3''', 'windows');
        expect(id.version, '2.0.6');
        expect(id.channel, 'stable');
        expect(id.operatingSystem, 'windows');
      }
      {
        var id = FlutterSdkId.parseFlutterVersionOutput('''
Flutter 2.2.0-10.2.pre • channel beta • https://github.com/flutter/flutter.git
Framework • revision b5017bf8de (5 days ago) • 2021-04-28 17:09:53 -0700
Engine • revision 91ed51e05c
Tools • Dart 2.13.0 (build 2.13.0-211.13.beta)''', 'macos');
        expect(id.version, '2.2.0-10.2.pre');
        expect(id.channel, 'beta');
        expect(id.operatingSystem, 'macos');
      }
      {
        var id = FlutterSdkId.parseFlutterVersionOutput('''
========
There is a new version of Flutter or something like that.
========

Flutter 2.0.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 1d9032c7e1 (4 days ago) • 2021-04-29 17:37:58 -0700
Engine • revision 05e680e202
Tools • Dart 2.12.3''', 'macos');
        expect(id.version, '2.0.6');
        expect(id.channel, 'stable');
        expect(id.operatingSystem, 'macos');
      }
      {
        var id = FlutterSdkId.parseFlutterVersionOutput('''
========
There is a new version of Flutter or something like that.
========
Flutter rocks
Flutter 2.0.6 • channel stable • https://github.com/flutter/flutter.git
Flutter 2.0.7
''', 'macos');
        expect(id.version, '2.0.6');
        expect(id.channel, 'stable');
        expect(id.operatingSystem, 'macos');
      }
      {
        var id = FlutterSdkId.parseFlutterVersionOutput('''
Flutter 2.2.0 • channel unknown • unknown source
Framework • revision b22742018b (10 days ago) • 2021-05-14 19:12:57 -0700
Engine • revision a9d88a4d18
Tools • Dart 2.13.0
''', 'macos');
        expect(id.version, '2.2.0');
        expect(id.channel, 'unknown');
        expect(id.operatingSystem, 'macos');
      }
    });

    test('parseFlutterVersionOutput throws', () {
      expect(() => FlutterSdkId.parseFlutterVersionOutput('''
Unexpected flutter version output
''', 'windows'), throwsArgumentError);
    });
  });
}
