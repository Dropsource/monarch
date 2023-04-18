import 'dart:io';

import 'package:async/async.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import '../../../test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {
  });

  tearDown(() async {
    await killMonarch();
  });

  test('monarch localizations warnings', () async {
    await Process.run(flutter_exe, ['clean']);
    await Process.run(flutter_exe, ['pub', 'get']);

    monarchRun =
        await TestProcess.start('monarch', ['run', '-v'], forwardStdio: false);

    // expect 4 monarch warnings
    await verifyStreamMessages(monarchRun!.stdout, [
      emitsThrough(contains('MONARCH WARNING')),
      emitsThrough(contains('MONARCH WARNING')),
      emitsThrough(contains('MONARCH WARNING')),
      emitsThrough(contains('MONARCH WARNING')),
      emitsThrough(startsWith('Launching Monarch app completed')),
    ]);

    {
      var stream = StreamQueue(monarchRun!.stdoutStream());

      await verifyStreamMessages(stream, [
        emitsThrough(
            '`@MonarchLocalizations` annotation on element `functionDelegate` will not be used. '),
        emits(
            'The `@MonarchLocalizations` annotation should be placed on a top-level getter or const.'),
      ]);
    }

    {
      var stream = StreamQueue(monarchRun!.stdoutStream());

      await verifyStreamMessages(stream, [
        emitsThrough(
            'Consider changing top-level variable `varDelegate` to a getter or const. Hot reloading works better '),
        emits('with top-level getters or const variables. '),
      ]);
    }

    {
      var stream = StreamQueue(monarchRun!.stdoutStream());

      await verifyStreamMessages(stream, [
        emitsThrough(
            "Type of `badLocalizationsDelegate` doesn't extend `LocalizationsDelegate<T>`. It will be ignored."),
      ]);
    }

    {
      var stream = StreamQueue(monarchRun!.stdoutStream());

      await verifyStreamMessages(stream, [
        emitsThrough(
            "`@MonarchLocalizations` annotation on `emptyDelegate` doesn't declare any locales. It will "),
        emits('be ignored.'),
      ]);
    }

    monarchRun!.kill();

    await Future.delayed(const Duration(milliseconds: 500));
    await monarchRun!.shouldExit();
  }, timeout: const Timeout(Duration(minutes: 2)));
}
