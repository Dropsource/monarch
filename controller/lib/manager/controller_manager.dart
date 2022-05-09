import 'dart:async';

import 'package:monarch_controller/data/channel_methods_sender.dart';
import 'package:monarch_controller/data/device_definitions.dart';
import 'package:monarch_controller/data/dock_definition.dart';
import 'package:monarch_controller/data/story_scale_definitions.dart';
import 'package:monarch_controller/data/visual_debug_flags.dart';
import 'package:monarch_controller/manager/controller_state.dart';
import 'package:rxdart/rxdart.dart';

import '../data/channel_methods_receiver.dart';
import '../data/monarch_data.dart';



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

  void onActiveStoryChanged(String key, String activeStoryName) async {
    _updateState((state) => state.copyWith(activeStoryName: activeStoryName));
    channelMethodsSender.loadStory('$key|$activeStoryName');
  }

  void update(ControllerState newState) {
    _streamController.sink.add(newState);
  }

  void _updateState(Function(ControllerState) stateReporter) {
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

  void onDockSettingsChange(DockDefinition dockDefinition) {
    update(state.copyWith(currentDock: dockDefinition));
    //todo send info that dock settings changes
  }
}
