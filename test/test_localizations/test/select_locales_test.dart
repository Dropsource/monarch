import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'package:monarch_test_utils/test_utils.dart';

void main() async {
  TestProcess? monarchRun;

  setUp(() async {});

  tearDown(() async {
    await killMonarch('test_localizations');
  });

  test('select locales', () async {
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
      if (projectData.localizations.length != 3) return false;
      var languageTags = projectData.localizations
          .map((e) => e.localeLanguageTags)
          .expand((element) => element)
          .toList();
      return languageTags.contains('en-US') &&
          languageTags.contains('es-US') &&
          languageTags.contains('fr-FR');
    })));

    var previewApi = await getPreviewApi(discoveryApiPort);

    var sampleStoriesKey =
        'test_localizations|stories/localized_sample_button_stories.meta_stories.g.dart';
    var sampleStoriesPath = 'stories/localized_sample_button_stories.dart';

    await previewApi.setStory(StoryIdInfo(
        storiesMapKey: sampleStoriesKey,
        package: 'test_localizations',
        path: sampleStoriesPath,
        storyName: 'primary'));

    await previewApi.setLocale(LocaleInfo(languageTag: 'fr-FR'));
    await previewApi.setLocale(LocaleInfo(languageTag: 'en-US'));
    await previewApi.setLocale(LocaleInfo(languageTag: 'es-US'));

    await briefly;

    var selections = await previewApi.getSelectionsState(Empty());
    expect(selections.storyId.storyName, equals('primary'));
    expect(selections.locale.languageTag, 'es-US');

    monarchRun!.kill();
    await monarchRun!.shouldExit();
    heartbeat.complete();
  });
}
