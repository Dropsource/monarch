import 'dart:io';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import '../../../test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {});

  tearDown(() async {
    await killMonarch('test_themes');
  });

  test('select themes', () async {
    await Process.run(flutter_exe, ['pub', 'get']);

    var discoveryApiPort = getRandomPort();

    monarchRun = await TestProcess.start('monarch',
        ['run', '-v', '--discovery-api-port', discoveryApiPort.toString()],
        forwardStdio: false);
    var heartbeat = TestProcessHeartbeat(monarchRun!)..start();

    var stdout_ = monarchRun!.stdout;
    await expectLater(
        stdout_, emitsThrough(startsWith('Launching Monarch app completed')));

    var previewApi = await getPreviewApi(discoveryApiPort);

    var referenceDataInfo = await previewApi.getReferenceData(Empty());
    expect(referenceDataInfo.standardThemes, hasLength(2));

    var projectDataInfo = await previewApi.getProjectData(Empty());
    expect(projectDataInfo.themes, hasLength(3));
    expect(
        projectDataInfo.themes.map((e) => e.name).toList(),
        containsAll([
          'Theme Getter - Dark',
          'Theme Variable - Dark',
          'Theme Final Variable - Light'
        ]));

    var selections = await previewApi.getSelectionsState(Empty());
    expect(selections.theme.id, '__material-light-theme__');

    expectLater(stdout_, neverEmits(errorPattern));

    var sampleStoriesKey =
        'test_themes|stories/sample_button_stories.meta_stories.g.dart';
    var sampleStoriesPath = 'stories/sample_button_stories.dart';

    await previewApi.setStory(StoryIdInfo(
        storiesMapKey: sampleStoriesKey,
        package: 'test_themes',
        path: sampleStoriesPath,
        storyName: 'primary'));

    var themeGetterDark = projectDataInfo.themes
        .firstWhere((element) => element.name == 'Theme Getter - Dark');
    var themeVariableDark = projectDataInfo.themes
        .firstWhere((element) => element.name == 'Theme Variable - Dark');
    var themeFinalVariableLight = projectDataInfo.themes.firstWhere(
        (element) => element.name == 'Theme Final Variable - Light');

    await previewApi.setTheme(themeGetterDark);
    await previewApi.setTheme(themeVariableDark);
    await previewApi.setTheme(themeFinalVariableLight);

    await briefly;

    selections = await previewApi.getSelectionsState(Empty());
    expect(selections.storyId.storyName, equals('primary'));
    expect(selections.theme.id, themeFinalVariableLight.id);

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();
  });
}
