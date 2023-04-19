import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import '../../../test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {});

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

    monarchRun!.kill();
    await monarchRun!.shouldExit();

    StringBuffer outputBuffer = StringBuffer();
    await monarchRun!.stdoutStream().forEach(outputBuffer.writeln);
    var output = outputBuffer.toString();

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
`@MonarchLocalizations` annotation on element `functionDelegate` will not be used. 
The `@MonarchLocalizations` annotation should be placed on a top-level getter or const.
════════════════════════════════════════════════════════════════════════════════════════════════════'''));

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Consider changing top-level variable `varDelegate` to a getter or const. Hot reloading works better 
with top-level getters or const variables. 

Proposed change:
```
@MonarchLocalizations(...)
SampleLocalizationsDelegate get varDelegate => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/internationalization
════════════════════════════════════════════════════════════════════════════════════════════════════'''));

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Type of `badLocalizationsDelegate` doesn't extend `LocalizationsDelegate<T>`. It will be ignored.
════════════════════════════════════════════════════════════════════════════════════════════════════'''));

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
`@MonarchLocalizations` annotation on `emptyDelegate` doesn't declare any locales. It will 
be ignored.
════════════════════════════════════════════════════════════════════════════════════════════════════'''));
  }, timeout: const Timeout(Duration(minutes: 1)));
}
