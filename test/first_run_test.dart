import 'dart:io';

import 'package:async/async.dart';
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
  IOSink? logSink;

  Future<void> verifyStreamMessages(
      StreamQueue<String> stream, List<StreamMatcher> matchers) async {
    for (var matcher in matchers) {
      await expectLater(stream, matcher);
      log('verified: ${matcher.description}');
    }
  }

  setUp(() async {
    var tempDir = Directory.systemTemp.createTempSync('monarch_test_');
    log('Test temp directory: ${tempDir.path}');

    var tempLogFile = File(p.join(tempDir.path, 'monarch_test.log'));
    await tempLogFile.create();
    logSink = tempLogFile.openWrite();

    log('Test log file: ${tempLogFile.path}');

    // TODO: refactor: log command, run command, write output to log file, print command 'done'
    {
      logSink!.writeln('---');
      logSink!.writeln(r'$ flutter create zeta');
      var result = await Process.run(flutter_exe, ['create', 'zeta'],
          workingDirectory: tempDir.path);
      logSink!.write(result.stdout);
      log('`flutter create zeta` done');
    }

    var zeta = p.join(tempDir.path, 'zeta');
    {
      logSink!.writeln('---');
      logSink!.writeln(r'$ monarch init -v');
      var result = await Process.run(monarch_exe, ['init', '-v'],
          workingDirectory: zeta);
      logSink!.write(result.stdout);
      log('`monarch init -v` done');
    }

    logSink!.writeln('---');
    logSink!.writeln(r'$ monarch run -v');
    monarchRun = await TestProcess.start(monarch_exe, ['run', '-v'],
        workingDirectory: zeta, forwardStdio: false);

    var byteStream =
        monarchRun!.stdoutStream().map((event) => "$event\n".codeUnits);
    logSink!.addStream(byteStream);

    log('`monarch run -v` started');
  });

  test('flutter create, monarch init, monarch run', () async {
    await verifyStreamMessages(monarchRun!.stdout, [
      emits(startsWith('Writing application logs to')),
      emitsThrough('Starting Monarch.'),
      emitsThrough('Preparing stories...'),
      emitsThrough('Launching Monarch app...'),
      emitsThrough('Attaching to stories...'),
      emitsThrough('Setting up stories watch...'),
      emitsThrough('Monarch key commands:'),
      emitsThrough(startsWith(
          'Monarch is ready. Project changes will reload automatically with hot reload.')),
    ]);

    await Future.delayed(Duration(milliseconds: 500));
    // monarchRun!.signal(ProcessSignal.sigint);
    // log('Sent ctrl+C to `monarch run`');
    monarchRun!.kill();
    log('sent kill to monarch run');
    await Future.delayed(Duration(milliseconds: 500));
    await monarchRun!.shouldExit();
  }, timeout: Timeout(Duration(minutes: 2)));

  tearDown(() async {
    logSink?.close();
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
