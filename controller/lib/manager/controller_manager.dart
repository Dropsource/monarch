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
import '../extensions/iterable_extensions.dart';

class ControllerManager with Log {
  final BehaviorSubject<ControllerState> _streamController =
      BehaviorSubject<ControllerState>();

  StreamSubscription<ControllerState>? _subscription;

  Stream<ControllerState> get stream => _streamController.stream;
  late ControllerState _state;

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
  }

  void onVisualDebugFlagToggled(VisualDebugFlag option) {
    channelMethodsSender
        .sendToggleVisualDebugFlag(option.copyWith(enabled: !option.isEnabled));
  }

  void onTextScaleFactorChanged(double val) {
    channelMethodsSender.setTextScaleFactor(val);
  }

  Iterable<StoryGroup> filterStories(List<StoryGroup> stories, String query) {
    return _searchManager.filterStories(stories, query);
  }

  void onVisualFlagToggle(String name, bool isEnabled) {
    final element =
        state.visualDebugFlags.firstWhere((element) => element.name == name);
    final index = state.visualDebugFlags.indexOf(element);
    final list = state.visualDebugFlags
      ..setAll(index, [element.copyWith(enabled: isEnabled)]);
    _update(state.copyWith(visualDebugFlags: list));
  }

  void launchDevTools() {
    cliGrpcClientInstance.client!.launchDevTools(Empty());
  }

  void onDeviceChanged(DeviceDefinition deviceDefinition) {
    _update(state.copyWith(currentDevice: deviceDefinition));
    channelMethodsSender.setActiveDevice(deviceDefinition.id);
  }

  void onThemeChanged(MetaTheme theme) {
    _update(state.copyWith(currentTheme: theme));
    channelMethodsSender.setActiveTheme(theme.id);
  }

  void onLocaleChanged(String locale) {
    _update(state.copyWith(currentLocale: locale));
    channelMethodsSender.setActiveLocale(locale);
  }

  void onScaleChanged(StoryScaleDefinition scaleDefinition) {
    _update(state.copyWith(currentScale: scaleDefinition));
    channelMethodsSender.setStoryScale(scaleDefinition.scale);
  }

  void onDockSettingsChange(DockDefinition dockDefinition) {
    _update(state.copyWith(currentDock: dockDefinition));
    channelMethodsSender.setDockSide(dockDefinition.id);
  }

  void onMonarchDataChanged(MonarchData monarchData) {
    log.finest('MonarchData '
        'meta-localizations=${monarchData.metaLocalizations.length} '
        'all-locales=${monarchData.allLocales.length} '
        'meta-themes=${monarchData.metaThemes.length} ');

    var localeHelper = _LocaleHelper(monarchData, state.currentLocale);
    localeHelper.compute();

    final allThemes = state.standardThemes + monarchData.metaThemes;
    final MetaTheme currentTheme = _checkCurrentTheme(allThemes);

    _update(state.copyWith(
      packageName: monarchData.packageName,
      storyGroups: _translateStories(monarchData.metaStoriesMap),
      userThemes: monarchData.metaThemes,
      currentTheme: currentTheme,
      locales: localeHelper.computedLocales,
      currentLocale: localeHelper.computedCurrentLocale,
    ));
  }

  void onDefaultThemeChange(String themeId) {
    MetaTheme? selectedTheme;
    final allThemes = state.standardThemes + state.userThemes;
    final currentTheme =
        allThemes.firstWhereOrNull((element) => element.id == themeId);

    if (currentTheme == null) {
      if (allThemes.isNotEmpty) {
        selectedTheme = allThemes.first;
      } else {
        //standard themes are empty, this should not happen, but just in case we are not selecting anything as currentTheme
      }
    } else {
      selectedTheme = currentTheme;
    }

    _update(state.copyWith(currentTheme: selectedTheme));
  }

  void onPreviewReady() {
    _update(state.copyWith(isPreviewReady: true));
  }

  void onStandardThemesChanged(List<MetaTheme> themes) {
    _update(state.copyWith(standardThemes: themes));
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

  MetaTheme _checkCurrentTheme(List<MetaTheme> allThemes) {
    if (!allThemes.contains(state.currentTheme)) {
      return state.standardThemes.first;
    } else {
      return state.currentTheme;
    }
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
  final String? currentLocale;
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
      if (currentLocale == null) {
        computedCurrentLocale = data.allLocales.first;
      } else {
        if (data.allLocales.contains(currentLocale!)) {
          computedCurrentLocale = currentLocale!;
        } else {
          computedCurrentLocale = data.allLocales.first;
        }
      }
    }
  }
}
