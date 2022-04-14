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

    _streamController.sink.add(WindowControllerState.test());
  }

  void onActiveStoryChanged(String activeStoryName) async {
      _updateState((state) => state.copyWith(activeStoryName: activeStoryName));
  }

  void onTextScaleFactorChanged(double val) {
    _updateState((state) => state.copyWith(textScaleFactor: val));
  }

  void _updateState(Function(WindowControllerState) stateReporter){
    if (state != null) {
      _streamController.sink
          .add(stateReporter(state!));
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _streamController.close();
  }

}
