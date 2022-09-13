import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:package_config/src/package_config_json.dart';
import 'package:monarch_cli/src/config/package_config_helper.dart';
import 'package:test/test.dart';

class PackageConfigHelperTester extends PackageConfigHelper {
  PackageConfigHelperTester({required this.packageConfigContents})
      : super(Directory.current);

  final String packageConfigContents;
  @override
  Future<void> setUp() async {
    packageConfig = parsePackageConfigBytes(
        // ignore: unnecessary_cast
        utf8.encode(packageConfigContents) as Uint8List,
        Uri.parse('file:///tmp/.dart_tool/file.dart'),
        throwError);
  }
}

void throwError(Object error) => throw error;

void main() {
  group('PackageConfigHelper', () {
    group('on windows', () {
      test('parses file uri to windows path', () async {
        final helper = PackageConfigHelperTester(
            packageConfigContents: someWindowsPackageConfig);
        await helper.setUp();

        expect(helper.hasPackage('args'), isTrue);
        expect(helper.hasPackage('convert'), isTrue);
        expect(helper.hasPackage('flutter'), isTrue);
        expect(helper.hasPackage('foobar'), isFalse);

        expect(helper.getPackageRootPath('args'),
            r'C:\Users\john\flutter\.pub-cache\hosted\pub.dartlang.org\args-2.3.0');
        expect(helper.getPackageRootPath('convert'),
            r'C:\Users\john\flutter\.pub-cache\hosted\pub.dartlang.org\convert-3.0.1');
        expect(helper.getPackageRootPath('flutter'),
            r'C:\Users\john\flutter\packages\flutter');
      });
    }, testOn: 'windows');

    group('on macos', () {
      test('parses file uri to macos path', () async {
        final helper = PackageConfigHelperTester(
            packageConfigContents: someMacosPackageConfig);
        await helper.setUp();

        expect(helper.hasPackage('args'), isTrue);
        expect(helper.hasPackage('convert'), isTrue);
        expect(helper.hasPackage('flutter'), isTrue);
        expect(helper.hasPackage('foobar'), isFalse);

        expect(helper.getPackageRootPath('args'),
            '/Users/john/flutter/.pub-cache/hosted/pub.dartlang.org/args-2.3.0');
        expect(helper.getPackageRootPath('convert'),
            '/Users/john/flutter/.pub-cache/hosted/pub.dartlang.org/convert-3.0.1');
        expect(helper.getPackageRootPath('flutter'),
            '/Users/john/flutter/packages/flutter');
      });
    }, testOn: 'mac-os');
  });

  group('FlutterPackageHelper', () {
    group('on windows', () {
      test('ends with trailing dirs', () {
        final helper = FlutterPackageHelper(r'C:\foo\bar\packages\flutter');
        expect(helper.endsWithTrailingDirs, isTrue);
      });
      test('does not end with trailing dirs', () {
        final helper = FlutterPackageHelper(r'C:\foo\bar\packages\floating');
        expect(helper.endsWithTrailingDirs, isFalse);
      });
      test('gets flutter executable path', () {
        final path = r'C:\Users\foo\development\flutter-sdk\packages\flutter';
        final helper = FlutterPackageHelper(path);
        expect(helper.getExecutablePath(),
            r'C:\Users\foo\development\flutter-sdk\bin\flutter');
      });
    }, testOn: 'windows');

    group('on macos', () {
      test('ends with trailing dirs', () {
        final helper = FlutterPackageHelper(r'/Users/foo/bar/packages/flutter');
        expect(helper.endsWithTrailingDirs, isTrue);
      });
      test('does not end with trailing dirs', () {
        final helper =
            FlutterPackageHelper(r'/Users/foo/bar/packages/floating');
        expect(helper.endsWithTrailingDirs, isFalse);
      });
      test('gets flutter executable path', () {
        final path = r'/Users/foo/development/flutter-sdk/packages/flutter';
        final helper = FlutterPackageHelper(path);
        expect(helper.getExecutablePath(),
            r'/Users/foo/development/flutter-sdk/bin/flutter');
      });
    }, testOn: 'mac-os');
  });
}

const someMacosPackageConfig = '''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "args",
      "rootUri": "file:///Users/john/flutter/.pub-cache/hosted/pub.dartlang.org/args-2.3.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "convert",
      "rootUri": "file:///Users/john/flutter/.pub-cache/hosted/pub.dartlang.org/convert-3.0.1",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "flutter",
      "rootUri": "file:///Users/john/flutter/packages/flutter",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    }
  ],
  "generator": "pub"
}
''';

const someWindowsPackageConfig = '''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "args",
      "rootUri": "file:///C:/Users/john/flutter/.pub-cache/hosted/pub.dartlang.org/args-2.3.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "convert",
      "rootUri": "file:///C:/Users/john/flutter/.pub-cache/hosted/pub.dartlang.org/convert-3.0.1",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "flutter",
      "rootUri": "file:///C:/Users/john/flutter/packages/flutter",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    }
  ],
  "generator": "pub"
}
''';
