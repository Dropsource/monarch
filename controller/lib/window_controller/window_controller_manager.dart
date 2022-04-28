import 'dart:async';

import 'package:monarch_window_controller/window_controller/data/visual_debug_flags.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';
import 'package:rxdart/rxdart.dart';

import 'data/monarch_data.dart';

class WindowControllerManager {
  final BehaviorSubject<WindowControllerState> _streamController =
      BehaviorSubject<WindowControllerState>();

  StreamSubscription<WindowControllerState>? _subscription;

  Stream<WindowControllerState> get stream => _streamController.stream;
  late WindowControllerState _state;
  WindowControllerState get state =>
      _state;



  WindowControllerManager({WindowControllerState? initialState}) {
    _subscription = _streamController.listen((value) {
      _state = value;
    });
    _streamController.sink.add(initialState ?? WindowControllerState.init());
  }

  void onActiveStoryChanged(String activeStoryName) async {
    _updateState((state) => state.copyWith(activeStoryName: activeStoryName));
  }

  void update(WindowControllerState newState){
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

    option = option.copyWith(enabled: !option.isEnabled);

    final element = state.visualDebugFlags.firstWhere((element) => element.name == option.name);
    final index = state.visualDebugFlags.indexOf(element);
    final list = state.visualDebugFlags..setAll(index, [option]);
    update(state.copyWith(visualDebugFlags: list));

    //TODO send information about [option] element updated to channel


  }

  void onTextScaleFactorChanged(double val) {}

  bool filterStories(MapEntry<String, MetaStories> element, String query) {
    final name = element.key;
    final storyNames = element.value.storiesNames;

    return name.contains(query) ||
        storyNames.where((element) => element.contains(query)).isNotEmpty;
  }
}


