import 'dart:io';
import 'dart:math';
import 'package:grpc/grpc.dart';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test_process/test_process.dart';
import 'package:test/test.dart';
import 'package:monarch_utils/timers.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:path/path.dart' as p;

import 'test_preview_notifications_api_service.dart';

/// Returns the monarch exe path as set by environment variable
/// MONARCH_EXE; if not set, then the monarch exe should be
/// sourced in the environment PATH before running these tests.
String monarch_exe = Platform.environment['MONARCH_EXE'] ?? '/Users/fertrig/development/monarch_product/monarch/out/monarch/bin/monarch';

/// Returns the flutter exe path as set by environment variables
/// FLUTTER_EXE; if not set, then the flutter exe should be sourced
/// in the environment PATH before running these tests.
String flutter_exe = Platform.environment['FLUTTER_EXE'] ?? 'flutter';

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

Matcher errorPattern() =>
    matches(RegExp(r'.*(error|severe).*', caseSensitive: false));

Future<void> killMonarch(String projectName) async {
  await futureForPlatform(
    macos: () async {
      await runProcess('pkill', ['Monarch']);
      await runProcess('pkill', [
        '-f',
        '.dart_tool/build/generated/$projectName/lib/main_monarch.g.dart'
      ]);
    },
    windows: () async {
      await runProcess(
          'taskkill', ['/F', '/IM', 'monarch_windows_app.exe', '/T']);
      await runProcess('taskkill', ['/F', '/IM', 'monarch.exe', '/T']);
    },
    linux: () async {
      await runProcess('pkill', ['-f', 'monarch_linux_app']);
      await runProcess('pkill', ['-f', 'monarch.run']);
      await runProcess('pkill', [
        '-f',
        '.dart_tool/build/generated/$projectName/lib/main_monarch.g.dart'
      ]);
    },
  );
}

String prettyCommand(String executable, Iterable<String> arguments) =>
    '$executable ${arguments.join(' ')}';

void print_(String message) {
  if (Platform.environment.containsKey('VERBOSE')) {
    print(message);
  }
}

Future<ProcessResult> runProcess(String executable, List<String> arguments,
        {String? workingDirectory,
        Map<String, String>? environment,
        bool includeParentEnvironment = true}) =>
    Process.run(executable, arguments,
        workingDirectory: workingDirectory,
        environment: environment,
        includeParentEnvironment: includeParentEnvironment,
        runInShell: Platform.isWindows);

Future<void> runProcessFancy(
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
      workingDirectory: workingDirectory, runInShell: Platform.isWindows);
  sink.write(result.stdout);
  heartbeat.complete();
}

Future<TestProcess> startTestProcess(
        String executable, Iterable<String> arguments,
        {String? workingDirectory,
        Map<String, String>? environment,
        bool includeParentEnvironment = true,
        bool runInShell = false,
        String? description,
        bool forwardStdio = false}) =>
    TestProcess.start(executable, arguments,
        workingDirectory: workingDirectory,
        includeParentEnvironment: includeParentEnvironment,
        runInShell: Platform.isWindows,
        description: description,
        forwardStdio: forwardStdio);

Future<TestProcess> startTestProcessFancy(
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
      workingDirectory: workingDirectory,
      forwardStdio: false,
      runInShell: Platform.isWindows);

  var byteStream =
      testProcess.stdoutStream().map((event) => "$event\n".codeUnits);
  sink.addStream(byteStream);
  return testProcess;
}

Future<TestPreviewNotificationsApiService> setUpTestNotificationsApi(
    int discoveryApiPort) async {
  var notifications = TestPreviewNotificationsApiService();
  var server = Server([notifications]);
  await server.serve(port: 0);

  var discoveryChannel = constructClientChannel(discoveryApiPort);
  var discoveryApi = MonarchDiscoveryApiClient(discoveryChannel);
  await discoveryApi
      .registerPreviewNotificationsApi(ServerInfo(port: server.port!));

  return notifications;
}

Future<MonarchPreviewApiClient> getPreviewApi(int discoveryApiPort) async {
  var discoveryChannel = constructClientChannel(discoveryApiPort);
  var discoveryApi = MonarchDiscoveryApiClient(discoveryChannel);
  const maxRetries = 10;

  Future<int> getPreviewApiPort() async {
    var serverInfo = await discoveryApi.getPreviewApi(Empty());
    return serverInfo.hasPort() ? serverInfo.port : -1;
  }

  for (var i = 0; i < maxRetries; i++) {
    int port = await getPreviewApiPort();
    if (port > -1) {
      var channel = constructClientChannel(port);
      return MonarchPreviewApiClient(channel);
    }
    await Future.delayed(const Duration(milliseconds: 50));
  }

  fail(
      'Test could not get Preview API port from the Discovery API after $maxRetries attemps.');
}

Future<void> runFlutterCreate(String projectName,
    {required String workingDirectory, required IOSink sink}) async {
  var process = await startTestProcessFancy(flutter_exe, ['create', 'zeta'],
      workingDirectory: workingDirectory, sink: sink);
  var heartbeat = Heartbeat('`${process.description}`', print_)..start();
  await expectLater(process.stdout, emitsThrough('All done!'));
  await process.shouldExit();
  heartbeat.complete();
}

Future<void> runMonarchInit(String projectName,
    {required String workingDirectory, required IOSink sink}) async {
  await setEmailCapturedFlag(); 
  var process = await startTestProcessFancy(monarch_exe, ['init', '-v'],
      workingDirectory: workingDirectory, sink: sink);
  var heartbeat = Heartbeat('`${process.description}`', print_)..start();
  await expectLater(process.stdout,
      emitsThrough('Monarch successfully initialized in this project.'));
  await process.shouldExit();
  heartbeat.complete();
}

Future<void> setEmailCapturedFlag() =>
    emailCapturedFile.writeAsString('1', mode: FileMode.write);

Future<void> resetEmailCapturedFlag() => emailCapturedFile.delete();

String get userDirectoryEnvironmentVariable =>
    valueForPlatform(macos: 'HOME', windows: 'USERPROFILE', linux: 'HOME');

String? get userDirectoryPath =>
    Platform.environment[userDirectoryEnvironmentVariable];

String get dataDirectoryRelativePath => valueForPlatform(
    macos: 'Library/Application Support/com.dropsource.monarch/data',
    windows: r'AppData\Local\Monarch\data',
    linux: '.config/monarch/data');

File get emailCapturedFile => File(p.join(
    userDirectoryPath!, dataDirectoryRelativePath, 'email_captured.info'));

class TestProcessHeartbeat extends Heartbeat {
  TestProcessHeartbeat(TestProcess process)
      : super('`${process.description}`', print_);
}
