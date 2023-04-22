import 'dart:io';

import 'package:monarch_test_utils/test_utils.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';
import 'package:path/path.dart' as p;


void main() async {
  late Directory workingDir;
  late IOSink logSink;

  TestProcess? monarchInit;

  setUp(() async {
    workingDir = await createWorkingDirectory();
    logSink = await createLogFile(workingDir);
  });

  tearDown(() async {
    logSink.close();
  });

  test('monarch init success', () async {
    await runFlutterCreate('zeta',
        workingDirectory: workingDir.path, sink: logSink);

    var zeta = p.join(workingDir.path, 'zeta');

    monarchInit = await startTestProcessFancy(monarch_exe, ['init'],
        workingDirectory: zeta, sink: logSink);
    var heartbeat = TestProcessHeartbeat(monarchInit!)..start();

    var stdout_ = monarchInit!.stdout;
    await expectLater(stdout_, emits(startsWith('Using flutter sdk at')));
    await expectLater(stdout_, emitsThrough('## Stay in touch'));
    await expectLater(
        stdout_, emits('- GitHub: https://github.com/Dropsource/monarch'));
    await expectLater(
        stdout_, emits('- Twitter: https://twitter.com/monarch_app'));
    await expectLater(
        stdout_, emits('- Newsletter: https://monarchapp.io/docs/community'));
    await expectLater(
        stdout_, emitsThrough('## Initializing zeta with Monarch'));
    await expectLater(stdout_,
        emits('Adding dev_dependencies `monarch` and `build_runner`...'));
    await expectLater(stdout_, emits('Setting up build.yaml...'));
    await expectLater(
        stdout_, emits('Creating sample stories in stories directory...'));
    await expectLater(
        stdout_, emits('Adding .monarch directory to .gitignore...'));
    // await expectLater(stdout_, emits('Running "flutter pub get" in zeta...'));
    await expectLater(stdout_,
        emitsThrough('Monarch successfully initialized in this project.'));
    await expectLater(stdout_, emitsThrough('Now you can: '));
    await expectLater(
        stdout_,
        emits(
            '- run Monarch using "monarch run" to see a few sample stories, or '));
    await expectLater(
        stdout_,
        emits(
            '- write your first story (https://monarchapp.io/docs/write-first-story).'));

    await monarchInit!.shouldExit();
    heartbeat.complete();
  });

  test('monarch init in non-flutter directory', () async {
    await runFlutterCreate('yankee',
        workingDirectory: workingDir.path, sink: logSink);

    monarchInit = await startTestProcessFancy(monarch_exe, ['init'],
        workingDirectory: workingDir.path, sink: logSink);
    var heartbeat = TestProcessHeartbeat(monarchInit!)..start();

    var stdout_ = monarchInit!.stdout;
    await expectLater(stdout_, emits('Found configuration errors:'));
    await expectLater(
        stdout_,
        emits(
            '- Could not find pubspec.yaml, make sure this is a flutter project directory'));
    await expectLater(
        stdout_,
        emits(
            '- Could not find .dart_tool/package_config.json file, make sure to run `flutter pub get` first'));
    await expectLater(
        stdout_, emits('- Could not parse lockfile pubspec.lock.'));

    await monarchInit!.shouldExit();
    heartbeat.complete();
  });
}
