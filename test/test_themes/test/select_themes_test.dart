import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'package:monarch_test_utils/test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {});

  tearDown(() async {
    await killMonarch('test_themes');
  });

  test('select themes', () async {
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
      if (projectData.themes.length != 3) return false;
      var languageTags = projectData.themes
          .map((e) => e.name)
          .toList();
      return languageTags.contains('Theme Getter - Dark') &&
          languageTags.contains('Theme Variable - Dark') &&
          languageTags.contains('Theme Final Variable - Light');
    })));

    var previewApi = await getPreviewApi(discoveryApiPort);

    var referenceDataInfo = await previewApi.getReferenceData(Empty());
    expect(referenceDataInfo.standardThemes, hasLength(2));

    var projectDataInfo = await previewApi.getProjectData(Empty());
    
    var selections = await previewApi.getSelectionsState(Empty());
    expect(selections.theme.id, '__material-light-theme__');

    var sampleStoriesKey =
        'test_themes|stories/sample_button_stories.meta_stories.g.dart';
    var sampleStoriesPath = 'stories/sample_button_stories.dart';

    var themeGetterDark = projectDataInfo.themes
        .firstWhere((element) => element.name == 'Theme Getter - Dark');
    var themeVariableDark = projectDataInfo.themes
        .firstWhere((element) => element.name == 'Theme Variable - Dark');
    var themeFinalVariableLight = projectDataInfo.themes.firstWhere(
        (element) => element.name == 'Theme Final Variable - Light');

    previewApi.setStory(StoryIdInfo(
        storiesMapKey: sampleStoriesKey,
        package: 'test_themes',
        path: sampleStoriesPath,
        storyName: 'primary'));
    previewApi.setTheme(themeGetterDark);
    previewApi.setTheme(themeVariableDark);
    previewApi.setTheme(themeFinalVariableLight);

    await expectLater(
        notifications.selectionsStateStream,
        emitsThrough(predicate<SelectionsStateInfo>(
            (selections) => selections.storyId.storyName == 'primary')));

    await expectLater(
        notifications.selectionsStateStream,
        emitsThrough(predicate<SelectionsStateInfo>(
            (selections) => selections.theme.id == themeFinalVariableLight.id)));

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();
  });
}
