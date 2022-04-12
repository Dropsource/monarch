import 'package:monarch_utils/log.dart';

import '../elasticsearch/elasticsearch_api.dart';
import 'analytics_event.dart';

abstract class AbstractAnalyticsApi {
  Future<bool> recordSingleEvent(String collectionName, Object data);
  Future<bool> recordMultipleEvents(List<AnalyticsEvent> list);
}

class AnalyticsApi with Log implements AbstractAnalyticsApi {
  final api = ElasticsearchApi();

  AnalyticsApi() {
    log.level = LogLevel.OFF; // off until we implement analytics logging
  }

  @override
  Future<bool> recordSingleEvent(String collectionName, Object data) async {
    return api.indexDocument(collectionName, data, log);
  }

  @override
  Future<bool> recordMultipleEvents(List<AnalyticsEvent> list) async {
    return api.indexDocumentsInBulk(
        list.map((item) => IndexData(item.collectionName, item.properties)),
        log);
  }
}
