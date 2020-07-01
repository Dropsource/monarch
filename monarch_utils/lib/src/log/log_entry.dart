import 'log_level.dart';

class LogEntry {
  final LogLevel level;
  final String loggerName;
  final String message;
  final DateTime timestamp;

  final String errorDetails;
  final String stackTrace;

  LogEntry._(this.level, this.message, this.loggerName,
      this.errorDetails, this.stackTrace)
      : timestamp = DateTime.now();

  factory LogEntry.standard(
          LogLevel level, String message, String loggerName) =>
      LogEntry._(level, message, loggerName, null, null);

  factory LogEntry.withError(LogLevel level, String message,
          String loggerName, String errorDetails, String stackTrace) =>
      LogEntry._(level, message, loggerName, errorDetails, stackTrace);

  @override
  String toString() {
    return '$level $loggerName: $message';
  }

  String toStringOptions({bool includeTimestamp = false, bool includeLoggerName = false}) {
    final tokens = <String>[];
    if (includeTimestamp) {
      tokens.add(timestamp.toString());
    }
    tokens.add(level.toString());
    if (includeLoggerName) {
      tokens.add('[$loggerName]');
    }
    tokens.add(message);

    return tokens.join(' ');
  }
}
