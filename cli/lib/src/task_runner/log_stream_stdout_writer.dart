import 'dart:async';

import 'package:monarch_utils/log.dart';
import '../utils/standard_output.dart';
import '../crash_reports/recurrence_log_entry.dart';
import 'task_names.dart';

/// Writes log entries to stdout_default so the user can see them. 
/// It only writes log entries that pass a certain threshold.
/// 
/// It will write all log entries that are SEVERE or greater, OR
/// log entries from task generate-meta-stories that are WARNING
/// or greater.
/// 
/// The builders in the monarch package, which run as part of 
/// generate-meta-stories, use warnings to let the user know about misplaced
/// annotations or files. If we use severe entries instead of warnings,
/// then the build_runner will fail the build.
/// 
/// The monarch_cli code uses warnings for internal implementation details
/// we want to log to the log file. We usually don't want the user experience
/// to be polluted with warnings. We use warnings for internal or advanced 
/// troubleshooting.
/// 
/// When there is a condition we want the user to know about we can log a warning
/// and then print a user-friendly message.
/// 
/// The user can still see the warnings if they open the log file.
/// 
/// Summarizing logging warnings and severe entries:
/// - The user will see all severe log entries
/// - Warnings will be written to the log file, the user won't see them in the CLI
/// - Beware that the user can still read the log file, thus don't log sensitive
///   information
/// - Use warnings to handle expected error conditions. Log the actual error 
///   message in a warning and then print a user-friendly message. Example: 
///   monarch_ui_fetcher.dart
/// - Use warnings to log things that may be useful for troubleshooting which 
///   do not block the normal operation of monarch. Example: context_info.dart
/// - Builders from the monarch package can only use warnings to inform the user 
///   about issues with the annotations, thus we need to display those warnings 
///   to the user
class LogStreamStdoutWriter with Log {
  final Stream<RecurrenceLogEntry> logEntryStream;
  StreamSubscription? _subscription;

  LogStreamStdoutWriter(this.logEntryStream);

  void setUp() {
    _subscription = logEntryStream.listen((RecurrenceLogEntry recurrenceEntry) {
      final entry = recurrenceEntry.logEntry;
      // @GOTCHA: if you change this logic, update the documentation above
      if (entry.level >= LogLevel.SEVERE ||
          (entry.level >= LogLevel.WARNING &&
              entry.loggerName == TaskNames.generateMetaStories)) {
        final buffer = StringBuffer(entry.message);

        if (entry.errorDetails != null && recurrenceEntry.index == 0) {
          buffer.write('\n');
          buffer.write(entry.errorDetails);
        }

        if (entry.stackTrace != null && recurrenceEntry.index == 0) {
          buffer.write('\n');
          buffer.write(entry.stackTrace);
        }

        stdout_default.writelnOnly(buffer.toString());
      }
    });
  }

  Future<void> tearDown() async {
    await _subscription?.cancel();
  }
}
