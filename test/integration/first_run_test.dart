import 'dart:io';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';
import 'package:path/path.dart' as p;

import 'test_utils.dart';

void main() async {
  late Directory workingDir;
  late IOSink logSink;

  TestProcess? monarchRun;

  setUp(() async {
    workingDir = await createWorkingDirectory();
    logSink = await createLogFile(workingDir);
  });

  tearDown(() async {
    await killMonarch();
    logSink.close();
  });

  test('flutter create, monarch init, monarch run', () async {
    await runFlutterCreate('zeta',
        workingDirectory: workingDir.path, sink: logSink);

    var zeta = p.join(workingDir.path, 'zeta');
    await runMonarchInit('zeta', workingDirectory: zeta, sink: logSink);

    var discoveryApiPort = 56778;
    monarchRun = await startTestProcess(monarch_exe,
        ['run', '-v', '--discovery-api-port', discoveryApiPort.toString()],
        workingDirectory: zeta, sink: logSink);
    var heartbeat = TestProcessHeartbeat(monarchRun!)..start();

    var stdout_ = monarchRun!.stdout;
    await expectLater(
        stdout_, emits(startsWith('Writing application logs to')));
    await expectLater(stdout_, emitsThrough('Starting Monarch.'));
    await expectLater(stdout_, emitsThrough('Preparing stories...'));
    await expectLater(stdout_, emitsThrough('Launching Monarch app...'));
    await expectLater(stdout_, emitsThrough('Attaching to stories...'));
    await expectLater(stdout_, emitsThrough('Setting up stories watch...'));
    await expectLater(stdout_, emitsThrough('Monarch key commands:'));
    await expectLater(stdout_, emitsThrough(startsWith('Monarch is ready.')));

    var previewApi = await getPreviewApi(discoveryApiPort);
    var projectDataInfo = await previewApi.getProjectData(Empty());
    var sampleStoriesKey =
        'zeta|stories/sample_button_stories.meta_stories.g.dart';
    expect(projectDataInfo.storiesMap.containsKey(sampleStoriesKey), isTrue);
    expect(projectDataInfo.storiesMap, hasLength(1));
    expect(
        projectDataInfo.storiesMap[sampleStoriesKey]!.package, equals('zeta'));
    expect(projectDataInfo.storiesMap[sampleStoriesKey]!.path,
        equals('stories/sample_button_stories.dart'));
    expect(projectDataInfo.storiesMap[sampleStoriesKey]!.storiesNames,
        containsAll(['primary', 'secondary', 'disabled']));

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();
  }, timeout: Timeout(Duration(minutes: 2)));
}
