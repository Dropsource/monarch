import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';
import 'package:path/path.dart' as p;

String monarch_exe = 'monarch';
String flutter_exe = 'flutter';

void main() async {
  // if (arguments.isNotEmpty) {
  //   monarch_exe = arguments[0];
  //   flutter_exe = arguments[1];
  // }

  TestProcess? monarchRun;

  setUp(() async {
    var tempDir = Directory.systemTemp.createTempSync('monarch_test_');
    log('Test temp directory: ${tempDir.path}');
    await Process.run(flutter_exe, ['create', 'zeta'],
        workingDirectory: tempDir.path);
    log('`flutter create zeta` done');

    var zeta = p.join(tempDir.path, 'zeta');
    await Process.run(monarch_exe, ['init', '-v'], workingDirectory: zeta);
    log('`monarch init -v` done');

    monarchRun = await TestProcess.start(monarch_exe, ['run', '-v'],
        workingDirectory: zeta, forwardStdio: true);
    log('`monarch run -v` started');
  });

  test('flutter create, monarch init, monarch run', () async {
    await expectLater(
        monarchRun!.stdout, emits(startsWith('Writing application logs to')));
    await expectLater(monarchRun!.stdout, emitsThrough('Starting Monarch.'));
    await expectLater(monarchRun!.stdout, emitsThrough('Preparing stories...'));
    await expectLater(
        monarchRun!.stdout, emitsThrough('Launching Monarch app...'));
    await expectLater(
        monarchRun!.stdout, emitsThrough('Attaching to stories...'));
    await expectLater(
        monarchRun!.stdout, emitsThrough('Setting up stories watch...'));
    await expectLater(
        monarchRun!.stdout, emitsThrough('Monarch key commands:'));
    await expectLater(
        monarchRun!.stdout,
        emitsThrough(startsWith(
            'Monarch is ready. Project changes will reload automatically with hot reload.')));

    await Future.delayed(Duration(milliseconds: 500));
    // monarchRun!.signal(ProcessSignal.sigint);
    // log('Sent ctrl+C to `monarch run`');
    monarchRun!.kill();
    log('sent kill to monarch run');
    await Future.delayed(Duration(milliseconds: 500));
    await monarchRun!.shouldExit();
  }, timeout: Timeout(Duration(minutes: 2)));

  tearDown(() async {
    await Process.run('pkill', ['Monarch']);
    // monarchRun?.signal(ProcessSignal.sigint);
    // log('Sent ctrl+C to `monarch run` again');
    // await Future.delayed(Duration(milliseconds: 500));
    // await monarchRun?.shouldExit();
  });
}

void log(String message) {
  print('test: $message');
}
