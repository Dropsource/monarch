import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';
import 'package:path/path.dart' as p;
import 'package:monarch_utils/timers.dart';

import 'test_utils.dart';

String monarch_exe = 'monarch';
String flutter_exe = 'flutter';

void main() async {
  late Directory workingDir;
  late IOSink logSink;

  TestProcess? monarchRun;

  setUp(() async {
    workingDir = await createWorkingDirectory();
    logSink = await createLogFile(workingDir);
  });

  tearDown(() async {
    logSink.close();
  });

  test('flutter create, monarch init, monarch run', () async {
    await runProcess(flutter_exe, ['create', 'zeta'],
        workingDirectory: workingDir.path, sink: logSink);

    var zeta = p.join(workingDir.path, 'zeta');
    await runProcess(monarch_exe, ['init', '-v'],
        workingDirectory: zeta, sink: logSink);

    monarchRun = await startTestProcess(monarch_exe, ['run', '-v'],
        workingDirectory: zeta, sink: logSink);
    var heartbeat = Heartbeat(
        '`${prettyCommand(monarch_exe, ['run', '-v'])}`', print_,
        checkInterval: Duration(seconds: 5))
      ..start();

    await verifyStreamMessages(monarchRun!.stdout, [
      emits(startsWith('Writing application logs to')),
      emitsThrough('Starting Monarch.'),
      emitsThrough('Preparing stories...'),
      emitsThrough('Launching Monarch app...'),
      emitsThrough('Attaching to stories...'),
      emitsThrough('Setting up stories watch...'),
      emitsThrough('Monarch key commands:'),
      emitsThrough(startsWith('Monarch is ready.')),
    ]);

    await Future.delayed(Duration(milliseconds: 500));

    monarchRun!.kill();

    await Future.delayed(Duration(milliseconds: 500));
    await monarchRun!.shouldExit();
    heartbeat.complete();
  }, timeout: Timeout(Duration(minutes: 2)));

  tearDown(() async {
    await Process.run('pkill', ['Monarch']);
    await Process.run('pkill', ['-f', 'bin/cache/dart-sdk/bin/dart']);
    logSink.close();
  });
}
