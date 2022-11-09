import '../utils/retry_queue.dart';
import 'crash_report.dart';
import 'crash_reports_api.dart';
import 'crash_report_loggers.dart';

final _logger = crashReportLoggers.getLogger('CrashReportsQueue');

class CrashReportsQueue extends RetryQueue<CrashReport> {
  final CrashReportsApi api;

  CrashReportsQueue(this.api);

  @override
  Future<bool> batchProcess(List<CrashReport> list) async {
    final data = list.map((report) => report.properties);
    final isSuccess = await api.reportCrashesInBulk(data);
    if (isSuccess) {
      final crashIds = list.map((crash) => crash.id).toList();
      _logger.info('crashes reported successfully, crash_ids=$crashIds');
    }
    return isSuccess;
  }

  @override
  void logWarningMessage(String message) {
    _logger.warning(message);
  }
}
