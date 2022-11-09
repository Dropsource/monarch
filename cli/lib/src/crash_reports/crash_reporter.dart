import 'package:monarch_utils/log.dart';

import 'crash_report.dart';
import 'crash_reports_api.dart';
import 'crash_reports_queue.dart';
import 'crash_report_loggers.dart';

final _logger = crashReportLoggers.getLogger('CrashReporter');

abstract class CrashReporter {
  void send(LogEntry crashEntry, List<LogEntry> entries, int recurrenceIndex);
}

class CrashReporterImpl implements CrashReporter {
  final CrashReportBuilder builder;
  CrashReportsQueue _queue = CrashReportsQueue(CrashReportsApi());
  CrashReportsQueue get queue => _queue;

  CrashReporterImpl(this.builder);

  @override
  void send(
      LogEntry crashEntry, List<LogEntry> entries, int recurrenceIndex) async {
    try {
      final crashReport =
          builder.buildReport(crashEntry, entries, recurrenceIndex);
      _queue.enqueue(crashReport);
    } catch (e, s) {
      // users see severe logs, we don't want to surface crash reporting errors
      _logger.warning('error while reporting crash', e, s);

      // create a new queue just in case its internal state is unexpected
      _queue = CrashReportsQueue(CrashReportsApi());
    }
  }
}
