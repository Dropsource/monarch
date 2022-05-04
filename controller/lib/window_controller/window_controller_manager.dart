import 'dart:async';

import 'package:monarch_window_controller/window_controller/data/device_definitions.dart';
import 'package:monarch_window_controller/window_controller/data/story_scale_definitions.dart';
import 'package:monarch_window_controller/window_controller/data/visual_debug_flags.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';
import 'package:rxdart/rxdart.dart';

import 'data/channel_methods_receiver.dart';
import 'data/channel_methods_sender.dart';
import 'data/monarch_data.dart';

class WindowControllerManager {
  final BehaviorSubject<WindowControllerState> _streamController =
      BehaviorSubject<WindowControllerState>();

  StreamSubscription<WindowControllerState>? _subscription;

  Stream<WindowControllerState> get stream => _streamController.stream;
  late WindowControllerState _state;

  WindowControllerState get state => _state;

  WindowControllerManager({WindowControllerState? initialState}) {
    _subscription = _streamController.listen((value) {
      _state = value;
    });
    _streamController.sink.add(initialState ?? WindowControllerState.init());
  }

  void onActiveStoryChanged(String key, String activeStoryName) async {
    logger.warning('Selected story with name $activeStoryName');
    _updateState((state) => state.copyWith(activeStoryName: activeStoryName));
    channelMethodsSender.loadStory('$key|$activeStoryName');
  }

  void update(WindowControllerState newState) {
    _streamController.sink.add(newState);
  }

  void _updateState(Function(WindowControllerState) stateReporter) {
    _streamController.sink.add(stateReporter(state));
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _streamController.close();
  }

  void onDevToolOptionToggled(VisualDebugFlag option) {
    channelMethodsSender
        .sendToggleVisualDebugFlag(option.copyWith(enabled: !option.isEnabled));
  }

  void onTextScaleFactorChanged(double val) {
    channelMethodsSender.setTextScaleFactor(val);
  }

  Iterable<MapEntry<String, MetaStories>> filterStories(
      Map<String, MetaStories> stories, String query) {
    final filtered = stories.entries.map((e) {
      return MapEntry<String, MetaStories>(
          e.key,
          e.value.copyWith(
              storiesNames: e.value.storiesNames
                  .where((element) =>
                      element.toLowerCase().contains(query.toLowerCase()))
                  .toList()));
    });

    return filtered;

    // final name = element.key;
    // final storyNames = element.value.storiesNames;
    //
    // return name.contains(query) ||
    //     storyNames.where((element) => element.contains(query)).isNotEmpty;
  }

  void onVisualFlagToggle(String name, bool isEnabled) {
    final element =
        state.visualDebugFlags.firstWhere((element) => element.name == name);
    final index = state.visualDebugFlags.indexOf(element);
    final list = state.visualDebugFlags
      ..setAll(index, [element.copyWith(enabled: isEnabled)]);
    update(state.copyWith(visualDebugFlags: list));
  }

  void onDeviceChanged(DeviceDefinition deviceDefinition) {
    update(state.copyWith(currentDevice: deviceDefinition));
    channelMethodsSender.setActiveDevice(deviceDefinition.id);
  }

  void onThemeChanged(MetaTheme theme) {
    update(state.copyWith(currentTheme: theme));
    channelMethodsSender.setActiveTheme(theme.id);
  }

  void onLocaleChanged(String locale) {
    update(state.copyWith(currentLocale: locale));
    channelMethodsSender.setActiveLocale(locale);
  }

  void onScaleChanged(StoryScaleDefinition scaleDefinition) {
    update(state.copyWith(currentScale: scaleDefinition));
    channelMethodsSender.setStoryScale(scaleDefinition.scale);
  }
}
