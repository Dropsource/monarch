import 'package:monarch_utils/log.dart';

/// Parses the log level from the [message] string using the [logLevelRegex].
/// If it cannot find the log level in the [message], then it will use the
/// [fallbackLogLevel].
LogLevel parseLogLevel(
    String message, RegExp logLevelRegex, LogLevel fallbackLogLevel) {
  final logLevelMatch = logLevelRegex.firstMatch(message);

  var logLevel = fallbackLogLevel;

  if (logLevelMatch != null) {
    final logLevelString = logLevelMatch.group(1);
    logLevel = LogLevel.fromString(logLevelString, fallbackLogLevel);
  }

  return logLevel;
}
