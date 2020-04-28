import 'dart:async';

import 'logger.dart';
import 'log_entry.dart';
import 'log_level.dart';

final List<StreamSubscription> _subscriptions = [];

void logToConsole({bool recordTime = false}) {
  final subscription = logEntryStream.listen((LogEntry entry) {
    if (recordTime) {
      print('${entry.timestamp} $entry');
    } else {
      print(entry.toString());
    }

    if (entry.errorDetails != null) {
      print(
          '${entry.loggerName}: Error or Exception details:\n${entry.errorDetails}');
    }
    if (entry.stackTrace != null) {
      print('${entry.loggerName}: Stack trace:\n${entry.stackTrace}');
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

mixin Log {
  Logger _log;

  Logger get log {
    return _log ??= Logger(prefix);
  }

  String get prefix => runtimeType.toString();

  void logInfo(Object object) => log.info(object);

  void logWarning(Object object, [dynamic e]) {
    log.warning(object);
    if (e != null) {
      log.warning(object, e);
    }
  }

  void logError(Object object) => log.severe(object);

  void logException(Object object, dynamic e, StackTrace s) =>
      log.severe(object, e, s);

  static String kvp(String key, Object value) {
    return '$key=$value';
  }
}
