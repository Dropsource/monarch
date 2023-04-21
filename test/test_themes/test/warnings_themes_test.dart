import 'dart:io';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import '../../utils/test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {});

  tearDown(() async {
    await killMonarch('test_themes');
  });

  test('monarch themes warnings', () async {
    await Process.run(flutter_exe, ['clean']);
    await Process.run(flutter_exe, ['pub', 'get']);

    var discoveryApiPort = getRandomPort();

    monarchRun = await TestProcess.start('monarch',
        ['run', '-v', '--discovery-api-port', discoveryApiPort.toString()],
        forwardStdio: false);
    var heartbeat = TestProcessHeartbeat(monarchRun!)..start();

    // expect 4 monarch warnings
    var stdout_ = monarchRun!.stdout;
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(stdout_, emitsThrough(contains('MONARCH WARNING')));
    await expectLater(
        stdout_, emitsThrough(startsWith('Launching Monarch app completed')));

    // verify themes using preview-api
    var previewApi = await getPreviewApi(discoveryApiPort);
    var projectDataInfo = await previewApi.getProjectData(Empty());
    expect(projectDataInfo.themes, hasLength(3));
    expect(
        projectDataInfo.themes.map((e) => e.name).toList(),
        containsAll([
          'Theme Getter - Dark',
          'Theme Variable - Dark',
          'Theme Final Variable - Light'
        ]));

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();

    StringBuffer outputBuffer = StringBuffer();
    await monarchRun!.stdoutStream().forEach(outputBuffer.writeln);
    var output = outputBuffer.toString();

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
`@MonarchTheme` annotation on element `functionTheme` will not be used. The `@MonarchTheme` 
annotation should be placed on a top-level (or library) getter.

Proposed change:
```
@MonarchTheme(...)
ThemeData get functionTheme => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/themes
════════════════════════════════════════════════════════════════════════════════════════════════════'''));

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Consider changing top-level variable `varTheme` to a getter. Hot reloading works better with 
top-level getters. 

Proposed change:
```
@MonarchTheme(...)
ThemeData get varTheme => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/themes
════════════════════════════════════════════════════════════════════════════════════════════════════'''));

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Consider changing top-level variable `finalTheme` to a getter. Hot reloading works better with 
top-level getters. 

Proposed change:
```
@MonarchTheme(...)
ThemeData get finalTheme => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/themes
════════════════════════════════════════════════════════════════════════════════════════════════════'''));

    expect(output, contains('''
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Theme `Bad Theme` is not of type `ThemeData`. It will be ignored.
════════════════════════════════════════════════════════════════════════════════════════════════════'''));
  }, timeout: const Timeout(Duration(minutes: 1)));
}
