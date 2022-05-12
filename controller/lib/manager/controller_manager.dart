import 'dart:async';

import 'package:monarch_controller/data/channel_methods_sender.dart';
import 'package:monarch_controller/data/device_definitions.dart';
import 'package:monarch_controller/data/dock_definition.dart';
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/data/story_scale_definitions.dart';
import 'package:monarch_controller/data/visual_debug_flags.dart';
import 'package:monarch_controller/manager/controller_state.dart';
import 'package:rxdart/rxdart.dart';

import '../data/channel_methods_receiver.dart';
import '../data/monarch_data.dart';
import 'package:monarch_controller/data/definitions.dart' as defs;
import '../extensions/iterable_extensions.dart';

class ControllerManager {
  final BehaviorSubject<ControllerState> _streamController =
      BehaviorSubject<ControllerState>();

  StreamSubscription<ControllerState>? _subscription;

  Stream<ControllerState> get stream => _streamController.stream;
  late ControllerState _state;

  ControllerState get state => _state;

  ControllerManager({ControllerState? initialState}) {
    _subscription = _streamController.listen((value) {
      _state = value;
    });
    _streamController.sink.add(initialState ?? ControllerState.init());
  }

  void onActiveStoryChanged(String key) async {
    _update(state.copyWith(activeStoryKey: key));
    channelMethodsSender.loadStory(key);
  }

  void onDevToolOptionToggled(VisualDebugFlag option) {
    channelMethodsSender
        .sendToggleVisualDebugFlag(option.copyWith(enabled: !option.isEnabled));
  }

  void onTextScaleFactorChanged(double val) {
    channelMethodsSender.setTextScaleFactor(val);
  }

  Iterable<StoryGroup> filterStories(List<StoryGroup> stories, String query) {
    final filtered = stories.map((e) {
      return StoryGroup(
          groupName: e.groupName,
          stories: e.stories
              .where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()))
              .toList());
    });

    return filtered;
  }

  void onVisualFlagToggle(String name, bool isEnabled) {
    final element =
        state.visualDebugFlags.firstWhere((element) => element.name == name);
    final index = state.visualDebugFlags.indexOf(element);
    final list = state.visualDebugFlags
      ..setAll(index, [element.copyWith(enabled: isEnabled)]);
    _update(state.copyWith(visualDebugFlags: list));
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
    logger.finest(
        "monarchData - user localizations count: ${monarchData.metaLocalizations.length}");
    logger.finest(
        "monarchData - user theme count: ${monarchData.metaThemes.length}");
    logger.finest(
        "monarchData - key count in metaStoriesMap: ${monarchData.metaStoriesMap.length}");
    logger.finest("monarchData - package name: ${monarchData.packageName}");

    final allLocales = monarchData.allLocales.isNotEmpty
        ? monarchData.allLocales
        : [defs.defaultLocale];

    final String currentLocale = _checkCurrentLocale(allLocales);

    final allThemes = state.standardThemes + monarchData.metaThemes;
    final MetaTheme currentTheme = _checkCurrentTheme(allThemes);

    _update(state.copyWith(
      packageName: monarchData.packageName,
      storyGroups: _translateStories(monarchData.metaStoriesMap),
      userThemes: monarchData.metaThemes,
      currentTheme: currentTheme,
      locales: allLocales.toList(),
      currentLocale: currentLocale,
    ));

    channelMethodsSender.setActiveLocale(state.currentLocale);

    channelMethodsSender.setActiveTheme(state.currentTheme.id);
    channelMethodsSender.setActiveDevice(state.currentDevice.id);
    channelMethodsSender.setTextScaleFactor(state.textScaleFactor);
    channelMethodsSender.setStoryScale(state.currentScale.scale);
  }

  void onDefaultThemeChange(String themeId) {
    MetaTheme? selectedTheme;
    final allThemes = state.standardThemes + state.userThemes;
    final currentTheme =
        allThemes.firstWhereOrNull((element) => element.id == themeId);

    if (currentTheme == null) {
      if (allThemes.isNotEmpty) {
        selectedTheme = allThemes.first;
      }else{
        //standard themes are empty, this should not happen, but just in case we are not selecting anything as currentTheme
      }
    } else {
      selectedTheme = currentTheme;
    }

    _update(state.copyWith(currentTheme: selectedTheme));
  }

  void onReady() {
    _update(state.copyWith(isReady: true));
    //send first load signal
    channelMethodsSender.sendFirstLoadSignal();
    logger.info('story-flutter-window-ready');
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

  String _checkCurrentLocale(Iterable<String> allLocales) {
    if (!allLocales.contains(state.currentLocale)) {
      if (allLocales.isEmpty) {
        return defs.defaultLocale;
      } else {
        return allLocales.first;
      }
    } else {
      return state.currentLocale;
    }
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
}
