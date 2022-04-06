import 'dart:async';

import 'package:monarch_window_controller/window_controller/window_controller_state.dart';
import 'package:rxdart/rxdart.dart';

class WindowControllerManager {
  final BehaviorSubject<WindowControllerState> _streamController =
      BehaviorSubject<WindowControllerState>();

  StreamSubscription<WindowControllerState>? _subscription;

  Stream<WindowControllerState> get stream => _streamController.stream;
  WindowControllerState? state;

  WindowControllerManager() {
    _subscription = _streamController.listen((value) {
      state = value;
    });

    _streamController.sink.add(ConnectedWindowControllerState.test());
  }

  void onActiveStoryChanged(String activeStoryName) async {
    final localState = state;

    if (localState is ConnectedWindowControllerState) {
      _streamController.sink
          .add(localState.copyWith(activeStoryName: activeStoryName));
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _streamController.close();
  }
}
