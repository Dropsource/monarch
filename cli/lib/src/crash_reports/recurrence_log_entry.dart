import 'package:monarch_utils/log.dart';

class RecurrenceLogEntry {
  final LogEntry logEntry;
  final int index;

  RecurrenceLogEntry(this.logEntry, this.index);
}

class _Recurrence {
  final String message;
  final String? errorDetails;
  final String? stackTrace;

  int index = 0;

  _Recurrence(LogEntry entry)
      : message = entry.message,
        errorDetails = entry.errorDetails,
        stackTrace = entry.stackTrace;
}

class RecurrenceLogEntryConverter {
  final bool Function(LogEntry)? shouldTrackRecurrence;

  RecurrenceLogEntryConverter({this.shouldTrackRecurrence});

  final _map = <String, List<_Recurrence>>{};

  RecurrenceLogEntry toRecurrenceLogEntry(LogEntry entry) {
    if (shouldTrackRecurrence != null && shouldTrackRecurrence!(entry)) {
      return _acquireRecurrenceLogEntry(entry);
    } else {
      return RecurrenceLogEntry(entry, 0);
    }
  }

  RecurrenceLogEntry _acquireRecurrenceLogEntry(LogEntry entry) {
    final key = _getKey(entry);
    final hasKey = _map.containsKey(key);

    if (hasKey) {
      final recurrences = _map[key]!;
      for (var recurrence in recurrences) {
        if (_isContentEqual(entry, recurrence)) {
          recurrence.index++;
          return RecurrenceLogEntry(entry, recurrence.index);
        }
      }
      final recurrence = _Recurrence(entry);
      recurrences.add(recurrence);
      return RecurrenceLogEntry(entry, recurrence.index);
    } else {
      final recurrence = _Recurrence(entry);
      _map[key] = [recurrence];
      return RecurrenceLogEntry(entry, recurrence.index);
    }
  }

  String _getKey(LogEntry entry) =>
      '${entry.level}|${entry.loggerName}|${_getLength(entry.message)}|${_getLength(entry.errorDetails)}|${_getLength(entry.stackTrace)}';

  int _getLength(String? string) => string == null ? -1 : string.length;

  bool _isContentEqual(LogEntry a, _Recurrence b) =>
      a.message == b.message &&
      a.errorDetails == b.errorDetails &&
      a.stackTrace == b.stackTrace;
}
