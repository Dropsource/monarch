import 'dart:io';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'package:monarch_test_utils/test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {});

  tearDown(() async {
    await killMonarch('test_stories');
  });

  test('monarch stories warnings', () async {
    // await runProcess(flutter_exe, ['clean']);
    await runProcess(flutter_exe, ['pub', 'get']);

    var discoveryApiPort = getRandomPort();

    monarchRun = await startTestProcess(monarch_exe,
        ['run', '-v', '--discovery-api-port', discoveryApiPort.toString()],
        forwardStdio: false);
    var heartbeat = TestProcessHeartbeat(monarchRun!)..start();

    // expect 1 monarch warning
    var stdout_ = monarchRun!.stdout;
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
Function `ccc` is not of a story function of type `Widget Function()`. It will be ignored.
════════════════════════════════════════════════════════════════════════════════════════════════════'''));
  }, timeout: const Timeout(Duration(minutes: 1)));
}
