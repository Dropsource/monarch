import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';
import 'package:path/path.dart' as p;

import 'test_utils.dart';

String monarch_exe = 'monarch';
String flutter_exe = 'flutter';

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
    await runProcess(flutter_exe, ['create', 'zeta'],
        workingDirectory: workingDir.path, sink: logSink);

    var zeta = p.join(workingDir.path, 'zeta');

    monarchInit = await startTestProcess(monarch_exe, ['init'],
        workingDirectory: zeta, sink: logSink);

    await verifyStreamMessages(monarchInit!.stdout, [
      emits(startsWith('Using flutter sdk at')),
      emitsThrough('## Stay in touch'),
      emits('- GitHub: https://github.com/Dropsource/monarch'),
      emits('- Twitter: https://twitter.com/monarch_app'),
      emits('- Newsletter: https://monarchapp.io/docs/community'),
      emitsThrough('## Initializing zeta with Monarch'),
      emits('Adding dev_dependencies `monarch` and `build_runner`...'),
      emits('Setting up build.yaml...'),
      emits('Creating sample stories in stories directory...'),
      emits('Adding .monarch directory to .gitignore...'),
      emits('Running "flutter pub get" in zeta...'),
      emitsThrough('Monarch successfully initialized in this project.'),
      emitsThrough('Now you can: '),
      emits(
          '- run Monarch using "monarch run" to see a few sample stories, or '),
      emits(
          '- write your first story (https://monarchapp.io/docs/write-first-story).'),
    ]);

    await monarchInit!.shouldExit();
  });

  test('monarch init in non-flutter directory', () async {
    await runProcess(flutter_exe, ['create', 'yankee'],
        workingDirectory: workingDir.path, sink: logSink);

    monarchInit = await startTestProcess(monarch_exe, ['init'],
        workingDirectory: workingDir.path, sink: logSink);

    await verifyStreamMessages(monarchInit!.stdout, [
      emits('Found configuration errors:'),
      emits(
          '- Could not find pubspec.yaml, make sure this is a flutter project directory'),
      emits(
          '- Could not find .dart_tool/package_config.json file, make sure to run `flutter pub get` first'),
      emits('- Could not parse lockfile pubspec.lock.'),
    ]);

    await monarchInit!.shouldExit();
  });
}
