import 'dart:io';
import 'package:meta/meta.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';
import 'package:monarch_io_utils/utils.dart';

import 'src/analytics/analytics.dart';
import 'src/analytics/analytics_event.dart';
import 'src/crash_reports/crash_reports.dart';
import 'src/utils/cli_exit_code.dart';
import 'src/utils/log_stream_file_writer.dart';

mixin CommonExecutor {
  @protected
  late LogStreamFileWriter logStreamFileWriter;
  @protected
  late LogStreamCrashReporter logStreamCrashReporter;

  @protected
  bool isVerbose = false;
  @protected
  bool isCrashDebug = false;

  final crashReporter = CrashReporterImpl(CrashReportBuilder());
  final analytics = AnalyticsImpl(AnalyticsEventBuilder());

  @protected
  void setUpLogStreamWriters(String commandDescription) {
    logStreamFileWriter = LogStreamFileWriter(
        logEntryStream, commandDescription, isVerbose,
        printTimestamp: true, printLoggerName: true);
    logStreamFileWriter.setUp();

    final recurrenceConverter = RecurrenceLogEntryConverter();

    final crashStream = logEntryStream
        .where((entry) => entry.level >= LogLevel.WARNING)
        .map(recurrenceConverter.toRecurrenceLogEntry)
        .asBroadcastStream();

    logStreamCrashReporter = LogStreamCrashReporter(
        crashStream,
        isCrashDebug ? LogLevel.WARNING : LogLevel.SEVERE,
        crashReporter,
        isCrashDebug);
    logStreamCrashReporter.setUp();
  }

  @protected
  Future<void> exit_(CliExitCode exitCode) async {
    await pumpEventQueue(times: 100);

    final futures = [
      analytics.queue.whileProcessingWithTimeout(Duration(milliseconds: 1500)),
      crashReporter.queue
          .whileProcessingWithTimeout(Duration(milliseconds: 750)),
      logStreamFileWriter.tearDown(),
      logStreamCrashReporter.tearDown(),
    ];

    await Future.wait(futures);

    exit(exitCode.code);
  }
}
