import 'dart:io';
import 'dart:math';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test_process/test_process.dart';
import 'package:test/test.dart';
import 'package:monarch_utils/timers.dart';
import 'package:path/path.dart' as p;

/// The monarch exe should be sourced in the environment PATH
/// before running these tests.
String monarch_exe = 'monarch';

/// The flutter exe should be sourced in the environment PATH
/// before running these tests.
String flutter_exe = 'flutter';

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

/// 250ms delay.
Future<void> get briefly => Future.delayed(const Duration(milliseconds: 250));

/// Returns random number in the range 50000 to 55000, which could be use 
/// for a port number.
/// We could use platform APIs if we need a more precise way to get a port number.
/// Or if we need to make sure the port is not already in use.
int getRandomPort() {
  var random = Random();
  return random.nextInt(5000) + 50000;
}

Matcher errorPattern() => matches(RegExp(r'.*error.*', caseSensitive: false));

Future<void> killMonarch(String projectName) async {
  await Process.run('pkill', ['Monarch']);
  await Process.run('pkill', ['-f', '.dart_tool/build/generated/$projectName/lib/main_monarch.g.dart']);
}

String prettyCommand(String executable, Iterable<String> arguments) =>
    '$executable ${arguments.join(' ')}';

void print_(String message) {
  if (Platform.environment.containsKey('VERBOSE')) {
    print(message);
  }
}

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

Future<MonarchPreviewApiClient> getPreviewApi(int discoveryApiPort) async {
  var discoveryChannel = constructClientChannel(discoveryApiPort);
  var discoveryApi = MonarchDiscoveryApiClient(discoveryChannel);
  var previewApiServerInfo = await discoveryApi.getPreviewApi(Empty());
  expect(previewApiServerInfo.hasPort(), isTrue);
  var previewApiChannel = constructClientChannel(previewApiServerInfo.port);
  return MonarchPreviewApiClient(previewApiChannel);
}

Future<void> runFlutterCreate(String projectName,
    {required String workingDirectory, required IOSink sink}) async {
  var process = await startTestProcess(flutter_exe, ['create', 'zeta'],
      workingDirectory: workingDirectory, sink: sink);
  var heartbeat = Heartbeat('`${process.description}`', print_)..start();
  await expectLater(process.stdout, emitsThrough('All done!'));
  await process.shouldExit();
  heartbeat.complete();
}

Future<void> runMonarchInit(String projectName,
    {required String workingDirectory, required IOSink sink}) async {
  var process = await startTestProcess(monarch_exe, ['init', '-v'],
      workingDirectory: workingDirectory, sink: sink);
  var heartbeat = Heartbeat('`${process.description}`', print_)..start();
  await expectLater(process.stdout,
      emitsThrough('Monarch successfully initialized in this project.'));
  await process.shouldExit();
  heartbeat.complete();
}

class TestProcessHeartbeat extends Heartbeat {
  TestProcessHeartbeat(TestProcess process)
      : super('`${process.description}`', print_);
}
