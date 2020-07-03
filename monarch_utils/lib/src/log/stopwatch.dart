class Stopwatch {
  int _start;
  int _stop;

  void start() => _start = nowMicrosecondsSinceEpoch;
  void stop() => _stop = nowMicrosecondsSinceEpoch;

  Duration get duration {
    if (_start == null) {
      throw StateError('Stopwatch not started');
    } else if (_stop == null) {
      throw StateError('Stopwatch not stopped');
    } else {
      return Duration(microseconds: _stop - _start);
    }
  }

  @override
  String toString() {
    if (_start == null) {
      return 'stopwatch-not-started';
    } else if (_stop == null) {
      return 'stopwatch-not-stopped';
    } else {
      return prettyDuration(duration);
    }
  }
}

int get nowMicrosecondsSinceEpoch => now.microsecondsSinceEpoch;

/// Returns the given [duration] in a pretty format. Examples:
/// ```
/// 3µs
/// 998µs
/// 5ms
/// 678ms
/// 1.9sec
/// 59.5sec
/// 1.0min
/// 5.7min
/// ```
/// If the duration is small enough it will only return microseonds (µs) or
/// milliseconds (ms). If ms, then the µs will not be part of the returned
/// string.
///
/// If the duration is seconds (sec) or minutes (min), it will print a single
/// decimal point digit.
///
/// See stopwatch_test.dart for more details.
String prettyDuration(Duration duration) {
  if (duration.inMicroseconds < 1000) {
    return '${duration.inMicroseconds}µs';
  } else if (duration.inMilliseconds < 1000) {
    return '${duration.inMilliseconds}ms';
  } else if (duration.inSeconds < 60) {
    final seconds = duration.inMilliseconds / Duration.millisecondsPerSecond;
    return '${seconds.toStringAsFixed(1)}sec';
  } else {
    final minutes = duration.inSeconds / Duration.secondsPerMinute;
    return '${minutes.toStringAsFixed(1)}min';
  }
}

/// Used for testing.
DateTime manualNow;

DateTime get now => manualNow ?? DateTime.now();
