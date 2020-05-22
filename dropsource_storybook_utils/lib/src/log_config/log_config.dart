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
