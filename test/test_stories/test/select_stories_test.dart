import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'package:monarch_test_utils/test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {});

  tearDown(() async {
    await killMonarch('test_stories');
  });

  test('select stories', () async {
    await runProcess(flutter_exe, ['pub', 'get']);

    var discoveryApiPort = getRandomPort();

    monarchRun = await startTestProcess(monarch_exe,
        ['run', '-v', '--discovery-api-port', discoveryApiPort.toString()],
        forwardStdio: false);
    var heartbeat = TestProcessHeartbeat(monarchRun!)..start();

    var stdout_ = monarchRun!.stdout;

    await expectLater(stdout_, emitsThrough(startsWith('Starting Monarch.')));
    var notifications = await setUpTestNotificationsApi(discoveryApiPort);

    await expectLater(
        stdout_, emitsThrough(startsWith('Launching Monarch app completed')));

    await expectLater(notifications.projectDataStream,
        emitsThrough(predicate<ProjectDataInfo>((projectData) {
      if (projectData.storiesMap.length != 2) return false;
      var stories = projectData.storiesMap.values
          .expand((element) => element.storiesNames);
      return stories.contains('ggg') &&
          stories.contains('hhh') &&
          stories.contains('primary') &&
          stories.contains('secondary') &&
          stories.contains('disabled');
    })));

    var previewApi = await getPreviewApi(discoveryApiPort);

    var sampleStoriesKey =
        'test_stories|stories/sample_button_stories.meta_stories.g.dart';
    var sampleStoriesPath = 'stories/sample_button_stories.dart';

    var funkyStoriesKey =
        'test_stories|stories/funky_stories.meta_stories.g.dart';
    var funkyStoriesPath = 'stories/funky_stories.dart';

    var projectDataInfo = await previewApi.getProjectData(Empty());
    expect(projectDataInfo.storiesMap.containsKey(sampleStoriesKey), isTrue);
    expect(projectDataInfo.storiesMap.containsKey(funkyStoriesKey), isTrue);

    Future<void> setFunkyStory(String storyName) =>
        previewApi.setStory(StoryIdInfo(
            storiesMapKey: funkyStoriesKey,
            package: 'test_stories',
            path: funkyStoriesPath,
            storyName: storyName));

    Future<void> setSampleStory(String storyName) =>
        previewApi.setStory(StoryIdInfo(
            storiesMapKey: sampleStoriesKey,
            package: 'test_stories',
            path: sampleStoriesPath,
            storyName: storyName));

    setFunkyStory('hhh');
    setSampleStory('secondary');
    setFunkyStory('ggg');
    setSampleStory('primary');
    setFunkyStory('hhh');

    await expectLater(notifications.selectionsStateStream,
        emitsThrough(predicate<SelectionsStateInfo>((selections) {
      var storyId = selections.storyId;
      return storyId.storyName == 'hhh' &&
          storyId.package == 'test_stories' &&
          storyId.path == funkyStoriesPath &&
          storyId.storiesMapKey == funkyStoriesKey;
    })));

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();
  });
}
