import '../elasticsearch/elasticsearch_indexes.dart' as indexes;
import 'crash_report_loggers.dart';
import '../elasticsearch/elasticsearch_api.dart';

final _logger = crashReportLoggers.getLogger('CrashReportsApi');

const crashesIndex = indexes.crashes;

class CrashReportsApi {
  final _api = ElasticsearchApi();

  Future<bool> reportCrash(Object data) async {
    return _api.indexDocument(crashesIndex, data, _logger);
  }

  Future<bool> reportTestCrash(Object data) async {
    return _api.indexDocument('test_crashes_01', data, _logger);
  }

  Future<bool> reportCrashesInBulk(
      Iterable<Map<String, dynamic>> dataList) async {
    return _api.indexDocumentsInBulk(
        dataList.map((item) => IndexData(crashesIndex, item)), _logger);
  }
}
