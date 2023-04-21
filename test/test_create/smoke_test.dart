import 'dart:io';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';
import 'package:path/path.dart' as p;

import '../utils/test_utils.dart';

void main() async {
  late Directory workingDir;
  late IOSink logSink;

  TestProcess? monarchRun;

  setUp(() async {
    workingDir = await createWorkingDirectory();
    logSink = await createLogFile(workingDir);
  });

  tearDown(() async {
    await killMonarch('zeta');
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
    var sampleStoriesPath = 'stories/sample_button_stories.dart';
    expect(projectDataInfo.packageName, 'zeta');
    expect(projectDataInfo.storiesMap.containsKey(sampleStoriesKey), isTrue);
    expect(projectDataInfo.storiesMap, hasLength(1));
    expect(
        projectDataInfo.storiesMap[sampleStoriesKey]!.package, equals('zeta'));
    expect(projectDataInfo.storiesMap[sampleStoriesKey]!.path,
        equals(sampleStoriesPath));
    expect(projectDataInfo.storiesMap[sampleStoriesKey]!.storiesNames,
        containsAll(['primary', 'secondary', 'disabled']));
    expect(projectDataInfo.themes, hasLength(0));
    expect(projectDataInfo.localizations, hasLength(0));

    expectLater(stdout_, neverEmits(errorPattern()));

    Future<void> setStoryAndVerify(String storyName) async {
      await previewApi.setStory(StoryIdInfo(
          storiesMapKey: sampleStoriesKey,
          package: 'zeta',
          path: sampleStoriesPath,
          storyName: storyName));

      var selections = await previewApi.getSelectionsState(Empty());
      expect(selections.storyId.storyName, equals(storyName));
      await briefly;
    }

    await setStoryAndVerify('disabled');
    await setStoryAndVerify('secondary');
    await setStoryAndVerify('primary');

    var referenceDataInfo = await previewApi.getReferenceData(Empty());
    expect(referenceDataInfo.devices.length, greaterThan(10));
    expect(referenceDataInfo.standardThemes, hasLength(2));
    var someDeviceInfo = referenceDataInfo.devices[9];
    var someThemeInfo = referenceDataInfo.standardThemes[1];
    var scale125Info =
        referenceDataInfo.scales.firstWhere((element) => element.scale == 1.25);
    await previewApi.setDevice(someDeviceInfo);
    await previewApi.setTheme(someThemeInfo);
    await previewApi.setTextScaleFactor(TextScaleFactorInfo(scale: 1.5));
    await previewApi.setScale(scale125Info);
    await previewApi.toggleVisualDebugFlag(
        VisualDebugFlagInfo(name: 'showGuidelines', isEnabled: true));
    await briefly;

    var selections = await previewApi.getSelectionsState(Empty());
    expect(selections.device.id, someDeviceInfo.id);
    expect(selections.theme.id, someThemeInfo.id);
    expect(selections.locale.languageTag, 'System Locale');
    expect(selections.textScaleFactor, 1.5);
    expect(selections.scale.scale, 1.25);
    expect(selections.dock.id, 'right');
    expect(selections.visualDebugFlags['slowAnimations'], isFalse);
    expect(selections.visualDebugFlags['showGuidelines'], isTrue);
    expect(selections.visualDebugFlags['showBaselines'], isFalse);
    expect(selections.visualDebugFlags['highlightRepaints'], isFalse);
    expect(selections.visualDebugFlags['highlightOversizedImages'], isFalse);

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();
  }, timeout: Timeout(Duration(minutes: 2)));
}
