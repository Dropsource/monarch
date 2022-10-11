import 'dart:async';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:rxdart/rxdart.dart';

import 'controller_state.dart';
import 'search_manager.dart';
import '../data/stories.dart';
import '../data/visual_debug_flag_ui.dart';
import '../data/grpc.dart';

class ControllerManager with Log {
  final BehaviorSubject<ControllerState> _streamController =
      BehaviorSubject<ControllerState>();

  StreamSubscription<ControllerState>? _subscription;

  Stream<ControllerState> get stream => _streamController.stream;
  ControllerState _state = ControllerState.init();

  ControllerState get state => _state;
  final _searchManager = SearchManager();

  final MonarchPreviewApiClient previewApi;

  ControllerManager({required this.previewApi, ControllerState? initialState}) {
    _subscription = _streamController.listen((value) {
      _state = value;
    });
    _streamController.sink.add(initialState ?? ControllerState.init());
  }

  void _userSelection(String kind) {
    cliGrpcClientInstance.client!.userSelection(UserSelectionData(
      kind: kind,
      localeCount: state.locales.length,
      userThemeCount: state.userThemes.length,
      storyCount: state.storyCount,
      selectedDevice: state.currentDevice.id,
      selectedTextScaleFactor: state.textScaleFactor,
      selectedStoryScale: state.currentScale.scale,
      selectedDockSide: state.currentDock.id,
      slowAnimationsEnabled:
          state.visualDebugFlags[VisualDebugFlags.slowAnimations],
      highlightRepaintsEnabled:
          state.visualDebugFlags[VisualDebugFlags.highlightRepaints],
      showGuidelinesEnabled:
          state.visualDebugFlags[VisualDebugFlags.showGuidelines],
      highlightOversizedImagesEnabled:
          state.visualDebugFlags[VisualDebugFlags.highlightOversizedImages],
      showBaselinesEnabled:
          state.visualDebugFlags[VisualDebugFlags.showBaselines],
    ));
  }

  Iterable<StoryGroup> filterStories(List<StoryGroup> stories, String query) {
    return _searchManager.filterStories(stories, query);
  }

  /// Called by UI when the user toggles a visual debug checkbox.
  /// It will send a message to the preview api, which calls the preview window
  /// via channel methods, which will call the vm service extension method for
  /// the corresponding flag.
  void onVisualDebugFlagToggledByUi(String flagName, bool isEnabled) {
    previewApi.toggleVisualDebugFlag(
        VisualDebugFlagInfo(name: flagName, isEnabled: !isEnabled));
    _userSelection(getVisualDebugFlagToggledKey(flagName));
  }

  void launchDevTools() {
    previewApi.launchDevTools(Empty());
    _userSelection('launch_devtools_clicked');
  }

  void onSelectionsStateChanged({
    required String? storyKey,
    required DeviceDefinition device,
    required MetaThemeDefinition theme,
    required String locale,
    required StoryScaleDefinition scale,
    required double textScaleFactor,
    required DockDefinition dock,
    required Map<String, bool> visualDebugFlags,
  }) {
    _update(state.copyWith(
      activeStoryKey: storyKey,
      currentDevice: device,
      currentTheme: theme,
      currentLocale: locale,
      currentScale: scale,
      textScaleFactor: textScaleFactor,
      currentDock: dock,
      visualDebugFlags: visualDebugFlags,
    ));
  }

  void onActiveStoryChanged(String key) async {
    previewApi.setStory(StoryKeyInfo(storyKey: key));
    _userSelection('story_selected');
  }

  void onDeviceChanged(DeviceDefinition deviceDefinition) {
    previewApi.setDevice(DeviceInfoMapper().toInfo(deviceDefinition));
    _userSelection('device_selected');
  }

  void onThemeChanged(MetaThemeDefinition theme) {
    previewApi.setTheme(ThemeInfoMapper().toInfo(theme));
    _userSelection('theme_selected');
  }

  void onLocaleChanged(String locale) {
    previewApi.setLocale(LocaleInfo(languageTag: locale));
    _userSelection('locale_selected');
  }

  void onScaleChanged(StoryScaleDefinition scaleDefinition) {
    previewApi.setScale(ScaleInfoMapper().toInfo(scaleDefinition));
    _userSelection('story_scale_selected');
  }

  void onTextScaleFactorChanged(double val) {
    previewApi.setTextScaleFactor(TextScaleFactorInfo(scale: val));
    _userSelection('text_scale_factor_selected');
  }

  void onDockSettingsChange(DockDefinition dock) {
    previewApi.setDock(DockInfoMapper().toInfo(dock));
    _userSelection('dock_side_selected');
  }

  void onProjectDataChanged({
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

  void onStandardThemesChanged(List<MetaThemeDefinition> standardThemes) {
    var themeHelper = _ThemeHelper(
        standardThemes: standardThemes,
        userThemes: state.userThemes,
        currentTheme: state.currentTheme);

    _update(state.copyWith(
        standardThemes: standardThemes,
        currentTheme: themeHelper.getCurrentTheme()));
  }

  void onPreviewReady() {
    _update(state.copyWith(isPreviewReady: true));
  }

  void onStoryScaleDefinitionsChanged(
      List<StoryScaleDefinition> scaleDefinitions) {
    _update(state.copyWith(scaleList: scaleDefinitions));
  }

  void onDeviceDefinitionsChanged(List<DeviceDefinition> deviceDefinitions) {
    _update(state.copyWith(devices: deviceDefinitions));
  }

  void _update(ControllerState newState) {
    _streamController.sink.add(newState);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _streamController.close();
  }

  List<StoryGroup> _translateStories(
      Map<String, MetaStoriesDefinition> metaStoriesMap) {
    return metaStoriesMap.entries
        .map((group) => StoryGroup(
            groupName: _readStoryGroupName(group.key),
            groupKey: group.key,
            stories: group.value.storiesNames
                /// @NEXT: I want to create a richer Story object so I can pass
                /// a StoryInfo to preview api with these properies
                /// StoryInfo
                /// - MapKey (the key in the stories map)
                /// - package
                /// - path
                /// - storyName (the name of the stories in the list of stories in the path)
                /// Then change preview to use the richer object. It has gotten harder (i.e. repetetive and error prone) to 
                /// continue to parse the storyKey string, just pass a richer object around, like everything else.
                .map((story) => Story(key: '${group.key}|$story', name: story))
                .toList()))
        .toList();
  }

  String _readStoryGroupName(String key) {
    ///// As of 2020-04-15, the key looks like `$packageName|$generatedStoriesFilePath`
    //test|stories/sample_button_stories.main_generated.g.dart
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
