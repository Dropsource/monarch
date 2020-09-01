import 'dart:async';

import '../log/log_level.dart';
import '../log/log_entry.dart';

/// Automatically record stack traces for any message of this level or above.
///
/// Because this is expensive, this is off by default.
LogLevel recordStackTraceAtLevel = LogLevel.OFF;

/// Default log level
LogLevel _defaultLogLevel = LogLevel.ALL;
LogLevel get defaultLogLevel => _defaultLogLevel;
set defaultLogLevel(LogLevel value) => _defaultLogLevel = value;

Stream<LogEntry> get logEntryStream => logEntryStreamController.stream;
final logEntryStreamController = StreamController<LogEntry>.broadcast();

typedef WriteLineFunction = void Function(String);

/// Listens on [logEntryStream] and writes a standard string representation
/// of each log entry using [writeln].
StreamSubscription<LogEntry> writeLogEntryStream(WriteLineFunction writeln,
    {bool printTimestamp = false, bool printLoggerName = false}) {
  return logEntryStream.listen((LogEntry entry) => writeLogEntry(entry, writeln,
      printTimestamp: printTimestamp, printLoggerName: printLoggerName));
}

/// Writes a standard string representation [entry] using [writeln].
void writeLogEntry(LogEntry entry, WriteLineFunction writeln,
    {bool printTimestamp = false, bool printLoggerName = false}) {
  writeln(entry.toStringOptions(
      includeTimestamp: printTimestamp, includeLoggerName: printLoggerName));

  if (entry.errorDetails != null) {
    writeln('Error or Exception details:\n${entry.errorDetails}');
  }

  if (entry.stackTrace != null) {
    writeln('Stack trace:\n${entry.stackTrace}');
  }
}
