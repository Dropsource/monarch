import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'package:monarch_test_utils/test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {
    await runFlutterCleanUpgradeGet();
  });

  tearDown(() async {
    await killMonarch('test_localizations');
  });

  test('monarch localizations warnings', () async {
    var discoveryApiPort = getRandomPort();

    monarchRun = await startTestProcess(monarch_exe,
        ['run', '-v', '--discovery-api-port', discoveryApiPort.toString()],
        forwardStdio: false);
    var heartbeat = TestProcessHeartbeat(monarchRun!)..start();

    // expect 5 monarch warnings
    var stdout_ = monarchRun!.stdout;
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(
        stdout_, emitsThrough(startsWith('Attaching to stories completed')));

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();
    if (Platform.isWindows) killMonarch('test_localizations');

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

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
`@MonarchLocalizations` annotation on library stories/localizations_outkast.dart will not be used.
The `@MonarchLocalizations` annotation should be used in libraries inside the lib directory.
════════════════════════════════════════════════════════════════════════════════════════════════════'''));

  }, timeout: const Timeout(Duration(minutes: 1)));
}
