import 'package:monarch_utils/log.dart';

class CrashReportLoggers {
  final loggers = <Logger>[];

  LogLevel _logLevel = LogLevel.OFF;

  Logger getLogger(String name) {
    final logger = Logger(name);
    logger.level = _logLevel;
    loggers.add(logger);
    return logger;
  }

  void setIsCrashDebugFlag(bool isCrashDebug) {
    if (isCrashDebug) {
      _logLevel = LogLevel.ALL;
    } else {
      _logLevel = LogLevel.OFF;
    }

    for (var logger in loggers) {
      logger.level = _logLevel;
    }
  }

  bool any(String loggerName) {
    return loggers.any((l) => l.name == loggerName);
  }
}

final crashReportLoggers = CrashReportLoggers();
