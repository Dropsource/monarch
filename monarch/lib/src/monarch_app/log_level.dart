import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

void setDefaultLogLevel(int defaultLogLevelValue) {
  defaultLogLevel = _getLogLevelFromValue(defaultLogLevelValue);
}

LogLevel _getLogLevelFromValue(int logLevelValue) {
  for (var logLevel in LogLevel.LEVELS) {
    if (logLevel.value == logLevelValue) {
      return logLevel;
    }
  }
  return LogLevel.ALL;
}

bool get isVerbose => defaultLogLevel == LogLevel.ALL;
