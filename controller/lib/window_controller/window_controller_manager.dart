import 'dart:async';

import 'package:monarch_window_controller/window_controller/data/dev_tools_option.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';
import 'package:rxdart/rxdart.dart';

class WindowControllerManager {
  final BehaviorSubject<WindowControllerState> _streamController =
      BehaviorSubject<WindowControllerState>();

  StreamSubscription<WindowControllerState>? _subscription;

  Stream<WindowControllerState> get stream => _streamController.stream;
  late WindowControllerState _state;
  ConnectedWindowControllerState get state =>
      _state as ConnectedWindowControllerState;

  WindowControllerManager() {
    _subscription = _streamController.listen((value) {
      _state = value;
    });

    _streamController.sink.add(ConnectedWindowControllerState.init());
  }

  void onActiveStoryChanged(String activeStoryName) async {
    _updateState((state) => state.copyWith(activeStoryName: activeStoryName));
  }

  void onActiveStoryChanged(String activeStoryName) async {
    _streamController.sink
        .add(state.copyWith(activeStoryName: activeStoryName));
  }

  void _updateState(Function(WindowControllerState) stateReporter) {
    if (state != null) {
      _streamController.sink.add(stateReporter(state!));
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _streamController.close();
  }

  onDevToolOptionToggled(DevToolsOption option) {
    final localState = state;
    if (localState == null) {
      return;
    }
    if (localState.enabledDevToolsFeatures.contains(option.feature)) {
      _updateState((state) => state.copyWith(
          enabledDevToolsFeatures: localState.enabledDevToolsFeatures
            ..remove(option.feature)));
    } else {
      _updateState((state) => state.copyWith(
          enabledDevToolsFeatures: localState.enabledDevToolsFeatures
            ..add(option.feature)));
    }
  }
}

final manager = WindowControllerManager();
