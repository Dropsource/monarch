import 'package:monarch_utils/log.dart';

const _shortLogLevelNames = {
  'W': 'WARNING',
  'I': 'INFO',
  'S': 'SEVERE',
  'F': 'FINE',
};

/// Parses the log level from the [message] string using the [logLevelRegex].
/// If it cannot find the log level in the [message], then it will use the
/// [fallbackLogLevel].
///
/// The regex may capture the level name in group 1 (full name like "WARNING")
/// or group 2 (single letter like "W" used by build_runner 2.10+).
LogLevel parseLogLevel(
    String message, RegExp logLevelRegex, LogLevel fallbackLogLevel) {
  final logLevelMatch = logLevelRegex.firstMatch(message);

  var logLevel = fallbackLogLevel;

  if (logLevelMatch != null) {
    var logLevelString = logLevelMatch.group(1);
    if (logLevelString == null) {
      final shortLevel = logLevelMatch.group(2);
      logLevelString = _shortLogLevelNames[shortLevel];
    }
    logLevel = LogLevel.fromString(logLevelString, fallbackLogLevel);
  }

  return logLevel;
}
