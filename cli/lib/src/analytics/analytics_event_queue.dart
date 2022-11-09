import '../utils/retry_queue.dart';
import 'analytics_api.dart';
import 'analytics_event.dart';

class AnalyticsEventsQueue extends RetryQueue<AnalyticsEvent> {
  final AbstractAnalyticsApi api;

  AnalyticsEventsQueue(this.api);

  @override
  Future<bool> batchProcess(List<AnalyticsEvent> list) {
    return api.recordMultipleEvents(list);
  }

  @override
  void logWarningMessage(String message) {
    // Do nothing until we implement analytics logging
  }
}
