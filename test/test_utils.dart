import 'dart:io';

import 'package:async/async.dart';
import 'package:test_process/test_process.dart';
import 'package:test/test.dart';
import 'package:monarch_utils/timers.dart';
import 'package:path/path.dart' as p;

Future<Directory> createWorkingDirectory() async {
  var workingDir = await Directory.systemTemp.createTemp('monarch_test_');
  print_('''
Test working directory: 
  ${workingDir.path}
''');
  return workingDir;
}

Future<IOSink> createLogFile(Directory directory) async {
  var testLogFile = File(p.join(directory.path, 'monarch_test.log'));
  await testLogFile.create();
  var logSink = testLogFile.openWrite();

  print_('''
Writing processes output to: 
  ${testLogFile.path}
''');
  return logSink;
}

String prettyCommand(String executable, Iterable<String> arguments) =>
    '$executable ${arguments.join(' ')}';

void print_(String message) => null; //print(message);

Future<void> runProcess(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
  required IOSink sink,
}) async {
  var prettyCommand_ = prettyCommand(executable, arguments);
  var heartbeat = Heartbeat('`$prettyCommand_`', print_,
      checkInterval: Duration(seconds: 5))
    ..start();
  sink.writeln('---');
  sink.writeln('${workingDirectory}\$ $prettyCommand_');
  sink.writeln();
  var result = await Process.run(executable, arguments,
      workingDirectory: workingDirectory);
  sink.write(result.stdout);
  heartbeat.complete();
}

Future<TestProcess> startTestProcess(
  String executable,
  Iterable<String> arguments, {
  required String workingDirectory,
  required IOSink sink,
}) async {
  var prettyCommand_ = prettyCommand(executable, arguments);
  sink.writeln('---');
  sink.writeln('${workingDirectory}\$ $prettyCommand_');
  sink.writeln();
  var testProcess = await TestProcess.start(executable, arguments,
      workingDirectory: workingDirectory, forwardStdio: false);

  var byteStream =
      testProcess.stdoutStream().map((event) => "$event\n".codeUnits);
  sink.addStream(byteStream);
  return testProcess;
}

Future<void> verifyStreamMessages(
    StreamQueue<String> stream, List<StreamMatcher> matchers) async {
  for (var matcher in matchers) {
    await expectLater(stream, matcher);
    print_('verified: ${matcher.description}');
  }
}
