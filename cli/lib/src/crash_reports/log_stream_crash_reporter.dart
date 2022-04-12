import 'dart:async';

import 'package:monarch_utils/log.dart';

import '../utils/list_utils.dart';
import 'recurrence_log_entry.dart';
import 'crash_reporter.dart';
import 'crash_report_loggers.dart';

final _logger = crashReportLoggers.getLogger('CrashReporter');

class LogStreamCrashReporter {
  final Stream<RecurrenceLogEntry> logEntryStream;
  final LogLevel logLevelThreshold;
  final CrashReporter crashReporter;
  final bool isCrashDebug;
  final bool Function(LogEntry)? shouldIgnore;

  late StreamSubscription _subscription;
  final List<LogEntry> recentEntries = [];
  static const recentEntriesThreshold = 10;

  LogStreamCrashReporter(this.logEntryStream, this.logLevelThreshold,
      this.crashReporter, this.isCrashDebug,
      {this.shouldIgnore});

  var _isCreatingCrashReport = false;

  void setUp() {
    _logger.info(
        'Will report crashes for log entries with level $logLevelThreshold '
        'or greater');

    _subscription =
        logEntryStream.listen((RecurrenceLogEntry recurrenceEntry) async {
      final entry = recurrenceEntry.logEntry;
      recentEntries.add(entry);

      if (!_isCreatingCrashReport) {
        trimStartIfNeeded(recentEntries, recentEntriesThreshold);

        if (entry.level >= logLevelThreshold &&
            !_shouldIgnore(entry) &&
            !_isCrashReportLogger(entry) &&
            recurrenceEntry.index % 10 == 0) {
          _isCreatingCrashReport = true;
          // Sometimes one error is logged using multiple severe log entries.
          // Using Future.delayed to let a few more entries come in. The delay
          // cannot be too long or too short.
          await Future.delayed(Duration(milliseconds: 50));
          crashReporter.send(entry, recentEntries, recurrenceEntry.index);
          _isCreatingCrashReport = false;
        }
      }
    });
  }

  bool _shouldIgnore(LogEntry entry) =>
      shouldIgnore != null && shouldIgnore!(entry);

  bool _isCrashReportLogger(LogEntry entry) =>
      crashReportLoggers.any(entry.loggerName);

  Future<void> tearDown() async {
    await _subscription.cancel();
  }
}
