import 'dart:async';

import 'package:monarch_io_utils/utils.dart';

abstract class RetryQueue<T> {
  final queue = <T>[];
  final _inFlightQueue = <T>[];

  bool get isProcessing => _inFlightQueue.isNotEmpty || queue.isNotEmpty;
  Future get whileProcessing => whileTrue(() => isProcessing);

  void enqueue(T event) async {
    if (retryQueue.length >= 500) {
      logWarningMessage(
          '500 or more items in retry queue, removing the first one '
          'before processing a new item');
      retryQueue.removeAt(0);
    }

    if (isProcessing) {
      queue.add(event);
    } else {
      queue.add(event);
      await pumpEventQueue();
      await _processQueue();
    }
  }

  void logWarningMessage(String message);

  Future<void> _processQueue() async {
    if (queue.isNotEmpty && _inFlightQueue.isEmpty) {
      _inFlightQueue.addAll(queue);
      queue.clear();

      final isSuccess = await batchProcess(_inFlightQueue);

      if (!isSuccess) {
        _startRetries(_inFlightQueue);
      }

      _inFlightQueue.clear();
      await _processQueue();
    }
  }

  /// Returns true if the processing was successful. Otherwise, it should
  /// return false which will cause the [list] to be put back in the [retryQueue].
  Future<bool> batchProcess(List<T> list);

  final retryQueue = <T>[];
  final _inFlightRetryQueue = <T>[];

  bool get isRetrying =>
      _inFlightRetryQueue.isNotEmpty ||
      retryQueue.isNotEmpty ||
      (_retryTimer != null && _retryTimer!.isActive);
  Future get whileRetrying => whileTrue(() => isRetrying);

  Duration get timeBetweenRetries => Duration(seconds: 30);
  Timer? _retryTimer;

  void _startRetries(List<T> list) {
    retryQueue.addAll(list);
    if (_retryTimer == null || !_retryTimer!.isActive) {
      _retryTimer = Timer(timeBetweenRetries, _processRetryQueue);
    }
  }

  Future<void> _processRetryQueue() async {
    if (retryQueue.isNotEmpty && _inFlightRetryQueue.isEmpty) {
      _inFlightRetryQueue.addAll(retryQueue);
      retryQueue.clear();

      final isSuccess = await batchProcess(_inFlightRetryQueue);

      if (!isSuccess) {
        retryQueue.addAll(_inFlightRetryQueue);
      }

      _inFlightRetryQueue.clear();
      _retryTimer = Timer(timeBetweenRetries, _processRetryQueue);
    }
  }

  Future<void> whileProcessingWithTimeout(Duration timeLimit) {
    return whileProcessing.timeout(timeLimit,
        onTimeout: () => logWarningMessage(
            'Time limit reached while waiting on queue to finish processing'));
  }
}
