import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';
import 'package:uuid/uuid.dart';

import '../config/context_and_session.dart';

class CrashReport {
  final String id;
  final Map<String, dynamic> properties;
  CrashReport(this.id, this.properties);
}

class CrashReportBuilder with ContextAndSession {
  CrashReport buildReport(
      LogEntry crashEntry, List<LogEntry> entries, int recurrenceIndex) {
    final crashId = Uuid().v4();
    final properties =
        _buildCrashProperties(crashId, crashEntry, entries, recurrenceIndex);
    return CrashReport(crashId, properties);
  }

  Map<String, dynamic> _buildCrashProperties(String crashId,
      LogEntry crashEntry, List<LogEntry> entries, int recurrenceIndex) {
    final properties = <String, dynamic>{};

    properties['crash_id'] = crashId;
    properties['timestamp'] = DateTime.now().millisecondsSinceEpoch;
    properties['crash_entry'] = _getLogEntryProperties(crashEntry);
    properties['entries'] = _logEntriesToString(entries);
    properties['recurrence_index'] = recurrenceIndex;
    properties['session_id'] = sessionManager?.sessionId;
    properties['context_info'] = contextInfo?.toPropertiesMap();

    return properties;
  }

  Map<String, dynamic> _getLogEntryProperties(LogEntry entry) {
    return {
      'level': {'value': entry.level.value, 'name': entry.level.name},
      'logger_name': entry.loggerName,
      'message': entry.message,
      'error_details': entry.errorDetails,
      'stack_trace': entry.stackTrace,
      'timestamp': entry.timestamp.millisecondsSinceEpoch,
    };
  }

  String _logEntriesToString(List<LogEntry> entries) {
    final buffer = StringBuffer();
    for (var entry in entries) {
      writeLogEntry(entry, buffer.writeln,
          printTimestamp: true, printLoggerName: true);
    }
    return buffer.toString();
  }
}
