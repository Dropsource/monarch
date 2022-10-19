import 'dart:async';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:rxdart/rxdart.dart';

import 'controller_state.dart';
import 'controller_actions.dart';
import 'search_manager.dart';
import '../data/stories.dart';

class ControllerManager with Log {
  final BehaviorSubject<ControllerState> _streamController =
      BehaviorSubject<ControllerState>();
  StreamSubscription<ControllerState>? _subscription;
  Stream<ControllerState> get stream => _streamController.stream;

  ControllerState _state = ControllerState.init();
  ControllerActions? _actions;

  ControllerState get state => _state;
  ControllerActions? get actions => _actions;

  final _searchManager = SearchManager();

  ControllerManager({ControllerState? initialState}) {
    _subscription = _streamController.listen((value) {
      _state = value;
    });
    _streamController.sink.add(initialState ?? ControllerState.init());
  }

  void _update(ControllerState newState) {
    _streamController.sink.add(newState);
  }

  void setUpPreviewApi(MonarchPreviewApiClient previewApi) {
    _actions = ControllerActions(previewApi, state);
  }

  Future<void> loadInitialData() async {
    var previewApi = _actions!.previewApi;

    var referenceDataInfo = await previewApi.getReferenceData(Empty());
    referenceDataChanged(referenceDataInfo);

    var projectDataInfo = await previewApi.getProjectData(Empty());
    projectDataChanged(projectDataInfo);

    var selectionsStateInfo = await previewApi.getSelectionsState(Empty());
    selectionsStateChanged(selectionsStateInfo);

    _update(state.copyWith(isReady: true));
  }

  void referenceDataChanged(ReferenceDataInfo info) {
    _referenceDataChanged(
      devices: info.devices.map((e) => DeviceInfoMapper().fromInfo(e)).toList(),
      standardThemes: info.standardThemes
          .map((e) => ThemeInfoMapper().fromInfo(e))
          .toList(),
      scales: info.scales.map((e) => ScaleInfoMapper().fromInfo(e)).toList(),
    );
  }

  void _referenceDataChanged({
    required List<DeviceDefinition> devices,
    required List<MetaThemeDefinition> standardThemes,
    required List<StoryScaleDefinition> scales,
  }) {
    _update(state.copyWith(
      devices: devices,
      standardThemes: standardThemes,
      scaleList: scales,
    ));
  }

  void projectDataChanged(ProjectDataInfo info) {
    _projectDataChanged(
      packageName: info.packageName,
      storiesMap: info.storiesMap.map(
          (key, value) => MapEntry(key, StoriesInfoMapper().fromInfo(value))),
      projectThemes:
          info.projectThemes.map((e) => ThemeInfoMapper().fromInfo(e)).toList(),
      localizations: info.localizations
          .map((e) => LocalizationInfoMapper().fromInfo(e))
          .toList(),
    );
  }

  void _projectDataChanged({
    required String packageName,
    required Map<String, MetaStoriesDefinition> storiesMap,
    required List<MetaThemeDefinition> projectThemes,
    required List<MetaLocalizationDefinition> localizations,
  }) {
    var themeHelper = _ThemeHelper(
        standardThemes: state.standardThemes,
        userThemes: projectThemes,
        currentTheme: state.currentTheme);

    var allLocaleLanguageTags =
        localizations.expand((m) => m.localeLanguageTags);
    var localeHelper =
        _LocaleHelper(allLocaleLanguageTags, state.currentLocale);

    _update(state.copyWith(
      packageName: packageName,
      storyGroups: _translateStories(storiesMap),
      userThemes: projectThemes,
      currentTheme: themeHelper.getCurrentTheme(),
      locales: localeHelper.getLocales(),
      currentLocale: localeHelper.getCurrentLocale(),
    ));
  }

  void selectionsStateChanged(SelectionsStateInfo info) {
    _selectionsStateChanged(
      storyId:
          info.hasStoryId() ? StoryIdInfoMapper().fromInfo(info.storyId) : null,
      device: DeviceInfoMapper().fromInfo(info.device),
      theme: ThemeInfoMapper().fromInfo(info.theme),
      locale: info.locale.languageTag,
      scale: ScaleInfoMapper().fromInfo(info.scale),
      textScaleFactor: info.textScaleFactor,
      dock: DockInfoMapper().fromInfo(info.dock),
      visualDebugFlags: info.visualDebugFlags,
    );
  }

  void _selectionsStateChanged({
    required StoryId? storyId,
    required DeviceDefinition device,
    required MetaThemeDefinition theme,
    required String locale,
    required StoryScaleDefinition scale,
    required double textScaleFactor,
    required DockDefinition dock,
    required Map<String, bool> visualDebugFlags,
  }) {
    _update(state.copyWith(
      currentStoryId: storyId,
      currentDevice: device,
      currentTheme: theme,
      currentLocale: locale,
      currentScale: scale,
      textScaleFactor: textScaleFactor,
      currentDock: dock,
      visualDebugFlags: visualDebugFlags,
    ));
  }

  Iterable<StoryGroup> filterStories(List<StoryGroup> stories, String query) {
    return _searchManager.filterStories(stories, query);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _streamController.close();
  }

  List<StoryGroup> _translateStories(
      Map<String, MetaStoriesDefinition> metaStoriesMap) {
    return metaStoriesMap.entries.map((storiesMapEntry) {
      var storiesMapKey = storiesMapEntry.key;
      var storiesDefinition = storiesMapEntry.value;
      return StoryGroup(
          groupName: _parseStoriesFileName(storiesMapKey),
          groupKey: storiesMapKey,
          stories: storiesDefinition.storiesNames
              .map((storyName) => StoryId(
                  storiesMapKey: storiesMapKey,
                  package: storiesDefinition.package,
                  path: storiesDefinition.path,
                  storyName: storyName))
              .toList());
    }).toList();
  }

  String _parseStoriesFileName(String key) {
    ///// As of 2020-04-15, the key looks like `$packageName|$generatedStoriesFilePath`
    //test|stories/sample_button_stories.meta_stories.g.dart
    final firstSlash = key.indexOf('/');
    final firstDot = key.indexOf('.');
    return key.substring(firstSlash + 1, firstDot);
  }

  void onGroupToggle(String groupKey) {
    if (state.collapsedGroupKeys.contains(groupKey)) {
      state.collapsedGroupKeys.remove(groupKey);
    } else {
      state.collapsedGroupKeys.add(groupKey);
    }
  }
}

class _LocaleHelper {
  final Iterable<String> allLocaleLanguageTags;
  final String currentLocale;
  _LocaleHelper(this.allLocaleLanguageTags, this.currentLocale);

  String getCurrentLocale() => allLocaleLanguageTags.isEmpty
      ? defaultLocale
      : allLocaleLanguageTags.contains(currentLocale)
          ? currentLocale
          : allLocaleLanguageTags.first;

  List<String> getLocales() => allLocaleLanguageTags.isEmpty
      ? [defaultLocale]
      : allLocaleLanguageTags.toList();
}

class _ThemeHelper {
  final List<MetaThemeDefinition> standardThemes;
  final List<MetaThemeDefinition> userThemes;
  final MetaThemeDefinition currentTheme;

  _ThemeHelper({
    required this.standardThemes,
    required this.userThemes,
    required this.currentTheme,
  });

  List<MetaThemeDefinition> get allThemes => standardThemes + userThemes;

  MetaThemeDefinition getCurrentTheme() =>
      allThemes.any((x) => x.id == currentTheme.id)
          ? currentTheme
          : allThemes.first;
}
