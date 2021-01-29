import 'dart:async';

import 'package:monarch_utils/log.dart';


class ActiveTextScaleFactor with Log {

  double _activeTextScaleFactor = 1.0;
  double get activeTextScaleFactor => _activeTextScaleFactor;

  final _activeTextScaleFactorStreamController = StreamController<void>.broadcast();
  Stream<void> get activeTextScaleFactorStream => _activeTextScaleFactorStreamController.stream;

  void setActiveTextScaleFactor(double factor) {
    _activeTextScaleFactor = factor;
    _activeTextScaleFactorStreamController.add(null);
    log.fine('active text scale factor set: $factor');
  }

  void resetActiveTextScaleFactor() {
    _activeTextScaleFactor = 1.0;
  }

  void close() {
    _activeTextScaleFactorStreamController.close();
  }
}

final activeTextScaleFactor = ActiveTextScaleFactor();
