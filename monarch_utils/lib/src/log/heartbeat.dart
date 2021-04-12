import 'dart:async';

import 'stopwatch.dart';
import 'write_line_function.dart';

class Heartbeat {
  final String message;
  final WriteLineFunction writeln;
  final Duration checkInterval;

  Timer? _heartbeatTimer;
  Stopwatch? _stopwatch;

  Heartbeat(this.message, this.writeln,
      {this.checkInterval = const Duration(seconds: 3, milliseconds: 100)});

  void start() {
    _stopwatch = Stopwatch()..start();
    _heartbeatTimer = Timer.periodic(checkInterval, checkProgress);
    writeln('\n$message...');
  }

  bool get _isTimerActive => _heartbeatTimer?.isActive ?? false;

  bool get isActive => _isTimerActive && _stopwatch != null;

  void checkProgress(_) {
    writeln('${_stopwatch!..stop()} elapsed');
  }

  void complete() {
    if (!isActive) {
      throw StateError('cannot complete an inactive hearbeat');
    }

    _heartbeatTimer!.cancel();
    writeln('$message completed, took ${_stopwatch!..stop()}');
  }
}
