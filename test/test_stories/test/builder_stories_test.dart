import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'package:monarch_test_utils/test_utils.dart';

void main() async {
  TestProcess? buildRunner;

  setUp(() async {
    await runFlutterCleanUpgradeGet();
  });

  tearDown(() => null);

  test('stories builder codegen build_runner log messages', () async {
    buildRunner = await startTestProcess(
        dart_exe, ['run', 'build_runner', 'build', '--verbose'],
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
