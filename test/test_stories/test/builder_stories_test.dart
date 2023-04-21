import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import '../../../test_utils.dart';

void main() async {
  TestProcess? buildRunner;

  setUp(() => null);

  tearDown(() => null);

  test('stories builder codegen build_runner log messages', () async {
    await Process.run(flutter_exe, ['clean']);
    await Process.run(flutter_exe, ['pub', 'get']);

    buildRunner = await TestProcess.start(
        flutter_exe, ['pub', 'run', 'build_runner', 'build', '--verbose'],
        forwardStdio: false);

    expectLaterEndsWith(String message) =>
        expectLater(buildRunner!.stdout, emitsThrough(endsWith(message)));

    await expectLaterEndsWith(
        'Skipping: function `aaa` does not have a return type.');
    await expectLaterEndsWith(
        'Skipping: function `bbb` has parameters, story functions should have zero parameters.');
    await expectLaterEndsWith('Found potential story `Function ccc()`.');
    await expectLaterEndsWith(
        'Skipping: the return type of function `ddd` is not a NamedType, it is a GenericFunctionTypeImpl.');
    await expectLaterEndsWith(
        'Skipping: function `eee` has null parameters, it must be a getter.');
    await expectLaterEndsWith(
        'Skipping: declaration is not a FunctionDeclaration, it is a ClassDeclarationImpl.');
    await expectLaterEndsWith('Found potential story `Widget ggg()`.');
    await expectLaterEndsWith('Found potential story `Text hhh()`.');
    await expectLaterEndsWith('Skipping: function `_iii` is private.');

    await buildRunner!.shouldExit();
  });
}
