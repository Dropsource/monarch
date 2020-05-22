import 'dart:async';

import 'log_config.dart';
import '../log/log_entry.dart';
import '../log/log_level.dart';

final List<StreamSubscription> _subscriptions = [];

void logToConsole({bool printTimestamp = false, bool printLoggerName = false}) {
  final subscription = logEntryStream.listen((LogEntry entry) {

    print(entry.toStringOptions(
        includeTimestamp: printTimestamp, includeLoggerName: printLoggerName));

    if (entry.errorDetails != null) {
      print('Error or Exception details:\n${entry.errorDetails}');
    }
    
    if (entry.stackTrace != null) {
      print('Stack trace:\n${entry.stackTrace}');
    }
  });

  _subscriptions.add(subscription);
}

Future<void> cancelLogSubscriptions() async {
  for (var subscription in _subscriptions) {
    await subscription.cancel();
  }
  defaultLogLevel = LogLevel.ALL;
}