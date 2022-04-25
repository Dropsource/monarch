import 'dart:io';

import 'package:monarch_cli/src/config/context_info.dart';
import 'package:test/test.dart';

const xcodebuild_ok_output = '''
Xcode 11.3
Build version 11C29''';

const xcodebuild_unexpected_output = '''
foo
Xcode 11.3
Build version 11C29
''';

const msbuild_ok_output = '''
Microsoft (R) Build Engine version 16.7.0+b89cb5fde for .NET Framework
Copyright (C) Microsoft Corporation. All rights reserved.

16.7.0.37604''';

const msbuild_unexpected_output = '''
Microsoft (R) Build Engine version 16.7.0+b89cb5fde for .NET Framework
Copyright (C) Microsoft Corporation. All rights reserved.

16.7.0.37604
foo''';

void main() {
  group('xcodebuild', () {
    late ContextInfo contextInfo;

    setUp(() {
      contextInfo = ContextInfo(false);
    });

    test('can read xcodebuild version', () async {
      await contextInfo.readXcodebuildInfo(
          Future(() => ProcessResult(0, 0, xcodebuild_ok_output, null)));

      expect(contextInfo.platformBuildToolInfo, isNotNull);
      expect(contextInfo.platformBuildToolInfo!.toolName, 'xcodebuild');
      expect(contextInfo.platformBuildToolInfo!.version, '11.3');
      expect(contextInfo.platformBuildToolInfo!.buildVersion, '11C29');
    });

    test('bad exit code', () async {
      await contextInfo.readXcodebuildInfo(
          Future(() => ProcessResult(0, 1, null, 'some message')));

      expect(contextInfo.platformBuildToolInfo, isNull);
    });

    test('unexpected output', () async {
      await contextInfo.readXcodebuildInfo(Future(
          () => ProcessResult(0, 1, xcodebuild_unexpected_output, null)));

      expect(contextInfo.platformBuildToolInfo, isNull);
    });

    test('blank output', () async {
      await contextInfo
          .readXcodebuildInfo(Future(() => ProcessResult(0, 1, '', null)));

      expect(contextInfo.platformBuildToolInfo, isNull);
    });
  });

  group('MSBuild', () {
    late ContextInfo contextInfo;

    setUp(() {
      contextInfo = ContextInfo(false);
    });

    test('can read MSBuild version', () async {
      await contextInfo.readMSBuildInfo(
          Future(() => ProcessResult(0, 0, msbuild_ok_output, null)));

      expect(contextInfo.platformBuildToolInfo, isNotNull);
      expect(contextInfo.platformBuildToolInfo!.toolName, 'MSBuild');
      expect(contextInfo.platformBuildToolInfo!.version, '16.7.0.37604');
    });

    test('bad exit code', () async {
      await contextInfo.readMSBuildInfo(
          Future(() => ProcessResult(0, 1, null, 'some message')));

      expect(contextInfo.platformBuildToolInfo, isNull);
    });

    test('unexpected output', () async {
      await contextInfo.readMSBuildInfo(
          Future(() => ProcessResult(0, 1, msbuild_unexpected_output, null)));

      expect(contextInfo.platformBuildToolInfo, isNull);
    });

    test('blank output', () async {
      await contextInfo
          .readMSBuildInfo(Future(() => ProcessResult(0, 1, '', null)));

      expect(contextInfo.platformBuildToolInfo, isNull);
    });
  });
}
