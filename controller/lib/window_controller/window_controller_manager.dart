import 'dart:async';

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

  void update(ConnectedWindowControllerState newState) {
    _streamController.sink.add(newState);
  }

  void onActiveStoryChanged(String activeStoryName) async {
    _streamController.sink
        .add(state.copyWith(activeStoryName: activeStoryName));
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _streamController.close();
  }

}

final manager = WindowControllerManager();
