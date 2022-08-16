import 'dart:async';

import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';
import 'package:rxdart/rxdart.dart';

import 'controller_state.dart';
import 'search_manager.dart';
import '../data/abstract_channel_methods_sender.dart';
import '../data/device_definitions.dart';
import '../data/dock_definition.dart';
import '../data/stories.dart';
import '../data/story_scale_definitions.dart';
import '../data/visual_debug_flags.dart';
import '../data/monarch_data.dart';
import '../data/definitions.dart' as defs;
import '../data/grpc.dart';

class ControllerManager with Log {
  final BehaviorSubject<ControllerState> _streamController =
      BehaviorSubject<ControllerState>();

  StreamSubscription<ControllerState>? _subscription;

  Stream<ControllerState> get stream => _streamController.stream;
  ControllerState _state = ControllerState.init();

  ControllerState get state => _state;
  final _searchManager = SearchManager();
  final AbstractChannelMethodsSender channelMethodsSender;

  ControllerManager(
      {ControllerState? initialState, required this.channelMethodsSender}) {
    _subscription = _streamController.listen((value) {
      _state = value;
    });
    _streamController.sink.add(initialState ?? ControllerState.init());
  }

  void onActiveStoryChanged(String key) async {
    log.finest('changing active story to $key');
    _update(state.copyWith(activeStoryKey: key));
    channelMethodsSender.loadStory(key);
    _userSelection('story_selected');
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
      slowAnimationsEnabled: _isEnabled(Flags.slowAnimations),
      highlightRepaintsEnabled: _isEnabled(Flags.highlightRepaints),
      showGuidelinesEnabled: _isEnabled(Flags.showGuidelines),
      highlightOversizedImagesEnabled:
          _isEnabled(Flags.highlightOversizedImages),
      showBaselinesEnabled: _isEnabled(Flags.showBaselines),
    ));
  }

  bool _isEnabled(String flag) => state.visualDebugFlags
      .firstWhere((element) => element.name == flag)
      .isEnabled;

  Iterable<StoryGroup> filterStories(List<StoryGroup> stories, String query) {
    return _searchManager.filterStories(stories, query);
  }

  /// Called by UI when the user toggles a visual debug checkbox.
  /// It will send a message to the preview, which will call the vm service
  /// extension method for the corresponding flag.
  /// It doesn't update the controller state. The controller state is updated
  /// in [onVisualDebugFlagToggleByVmService] which is called after this function.
  void onVisualDebugFlagToggledByUi(VisualDebugFlag option) {
    channelMethodsSender
        .sendToggleVisualDebugFlag(option.copyWith(enabled: !option.isEnabled));
    _userSelection(option.toggled);
  }

  /// Called by the preview's vm-service-client via the method channels.
  /// It gets called after a visual debug flag is set by the UI. Thus, we set
  /// the controller state in this function.
  /// It is also called after the user sets a visual debug flag using DevTools.
  void onVisualDebugFlagToggleByVmService(String name, bool isEnabled) {
    final element =
        state.visualDebugFlags.firstWhere((element) => element.name == name);
    final index = state.visualDebugFlags.indexOf(element);
    final list = state.visualDebugFlags
      ..setAll(index, [element.copyWith(enabled: isEnabled)]);
    _update(state.copyWith(visualDebugFlags: list));
  }

  void launchDevTools() {
    cliGrpcClientInstance.client!.launchDevTools(Empty());
    _userSelection('launch_devtools_clicked');
  }

  void onDeviceChanged(DeviceDefinition deviceDefinition) {
    _update(state.copyWith(currentDevice: deviceDefinition));
    channelMethodsSender.setActiveDevice(deviceDefinition.id);
    _userSelection('device_selected');
  }

  void onThemeChanged(MetaTheme theme) {
    _update(state.copyWith(currentTheme: theme));
    channelMethodsSender.setActiveTheme(theme.id);
    _userSelection('theme_selected');
  }

  void onLocaleChanged(String locale) {
    _update(state.copyWith(currentLocale: locale));
    channelMethodsSender.setActiveLocale(locale);
    _userSelection('locale_selected');
  }

  void onScaleChanged(StoryScaleDefinition scaleDefinition) {
    _update(state.copyWith(currentScale: scaleDefinition));
    channelMethodsSender.setStoryScale(scaleDefinition.scale);
    _userSelection('story_scale_selected');
  }

  void onTextScaleFactorChanged(double val) {
    _update(state.copyWith(textScaleFactor: val));
    channelMethodsSender.setTextScaleFactor(val);
    _userSelection('text_scale_factor_selected');
  }

  void onDockSettingsChange(DockDefinition dockDefinition) {
    _update(state.copyWith(currentDock: dockDefinition));
    channelMethodsSender.setDockSide(dockDefinition.id);
    _userSelection('dock_side_selected');
  }

  void onMonarchDataChanged(MonarchData monarchData) {
    log.finest('MonarchData '
        'meta-localizations=${monarchData.metaLocalizations.length} '
        'all-locales=${monarchData.allLocales.length} '
        'meta-themes=${monarchData.metaThemes.length} ');

    var localeHelper = _LocaleHelper(monarchData, state.currentLocale);
    localeHelper.compute();
    var themeHelper = _ThemeHelper(
        standardThemes: state.standardThemes,
        userThemes: monarchData.metaThemes,
        defaultThemeId: state.defaultThemeId,
        currentTheme: state.currentTheme);
    themeHelper.compute();

    _update(state.copyWith(
      packageName: monarchData.packageName,
      storyGroups: _translateStories(monarchData.metaStoriesMap),
      userThemes: monarchData.metaThemes,
      currentTheme: themeHelper.computedCurrentTheme,
      locales: localeHelper.computedLocales,
      currentLocale: localeHelper.computedCurrentLocale,
    ));
  }

  void onStandardThemesChanged(List<MetaTheme> standardThemes) {
    var themeHelper = _ThemeHelper(
        standardThemes: standardThemes,
        userThemes: state.userThemes,
        defaultThemeId: state.defaultThemeId,
        currentTheme: state.currentTheme);
    themeHelper.compute();

    _update(state.copyWith(
        standardThemes: standardThemes,
        currentTheme: themeHelper.computedCurrentTheme));
  }

  void onDefaultThemeChange(String themeId) {
    var themeHelper = _ThemeHelper(
        standardThemes: state.standardThemes,
        userThemes: state.userThemes,
        defaultThemeId: themeId,
        currentTheme: state.currentTheme);
    themeHelper.compute();

    _update(state.copyWith(
        currentTheme: themeHelper.computedCurrentTheme,
        defaultThemeId: themeId));
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

  List<StoryGroup> _translateStories(Map<String, MetaStories> metaStoriesMap) {
    return metaStoriesMap.entries
        .map((group) => StoryGroup(
            groupName: _readStoryGroupName(group.key),
            groupKey: group.key,
            stories: group.value.storiesNames
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
  final MonarchData data;
  final String currentLocale;
  _LocaleHelper(this.data, this.currentLocale);

  List<String> computedLocales = [];
  String computedCurrentLocale = defs.defaultLocale;

  void compute() {
    computedLocales.clear();
    if (data.allLocales.isEmpty) {
      computedLocales.add(defs.defaultLocale);
      computedCurrentLocale = defs.defaultLocale;
    } else {
      computedLocales.addAll(data.allLocales);
      if (data.allLocales.contains(currentLocale)) {
        computedCurrentLocale = currentLocale;
      } else {
        computedCurrentLocale = data.allLocales.first;
      }
    }
  }
}

class _ThemeHelper {
  final List<MetaTheme> standardThemes;
  final List<MetaTheme> userThemes;
  final String defaultThemeId;
  final MetaTheme currentTheme;

  _ThemeHelper(
      {required this.standardThemes,
      required this.userThemes,
      required this.currentTheme,
      required this.defaultThemeId});

  List<MetaTheme> get allThemes => standardThemes + userThemes;
  MetaTheme computedCurrentTheme = defs.defaultTheme;

  void compute() {
    bool listHasCurrent = allThemes.any((x) => x.id == currentTheme.id);

    if (listHasCurrent) {
      computedCurrentTheme =
          allThemes.firstWhere((x) => x.id == currentTheme.id);
    } else {
      computedCurrentTheme = allThemes.firstWhere((x) => x.id == defaultThemeId,
          orElse: () => allThemes.first);
    }
  }
}
