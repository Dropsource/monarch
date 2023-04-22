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
    await expectLater(
        stdout_, emitsThrough(startsWith('Launching Monarch app completed')));

    var previewApi = await getPreviewApi(discoveryApiPort);
    var projectDataInfo = await previewApi.getProjectData(Empty());
    expect(projectDataInfo.storiesMap, hasLength(2));
    expect(
        projectDataInfo.storiesMap.values
            .expand((element) => element.storiesNames),
        containsAll(['ggg', 'hhh', 'primary', 'secondary', 'disabled']));
    expectLater(stdout_, neverEmits(errorPattern));

    var sampleStoriesKey =
        'test_stories|stories/sample_button_stories.meta_stories.g.dart';
    var sampleStoriesPath = 'stories/sample_button_stories.dart';

    var funkyStoriesKey =
        'test_stories|stories/funky_stories.meta_stories.g.dart';
    var funkyStoriesPath = 'stories/funky_stories.dart';

    expect(projectDataInfo.storiesMap.containsKey(sampleStoriesKey), isTrue);
    expect(projectDataInfo.storiesMap.containsKey(funkyStoriesKey), isTrue);

    Future<void> setFunkyStory(String storyName) async {
      await previewApi.setStory(StoryIdInfo(
          storiesMapKey: funkyStoriesKey,
          package: 'test_stories',
          path: funkyStoriesPath,
          storyName: storyName));
      await briefly;
    }

    Future<void> setSampleStory(String storyName) async {
      await previewApi.setStory(StoryIdInfo(
          storiesMapKey: sampleStoriesKey,
          package: 'test_stories',
          path: sampleStoriesPath,
          storyName: storyName));
      await briefly;
    }

    await setFunkyStory('hhh');
    await setSampleStory('secondary');
    await setFunkyStory('ggg');
    await setSampleStory('primary');
    await setFunkyStory('hhh');

    var selections = await previewApi.getSelectionsState(Empty());
    expect(selections.storyId.storyName, equals('hhh'));
    expect(selections.storyId.package, equals('test_stories'));
    expect(selections.storyId.path, equals(funkyStoriesPath));
    expect(selections.storyId.storiesMapKey, equals(funkyStoriesKey));

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();
  });
}
