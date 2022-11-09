import 'package:uuid/uuid.dart';
import 'package:monarch_utils/log.dart';

import '../config/context_and_session.dart';
import '../utils/cli_exit_code.dart';

const addons = 'addons';
const notAvailable = 'not-available';

class AnalyticsEvent {
  final String collectionName;
  final Map<String, dynamic> properties;

  AnalyticsEvent(this.collectionName, this.properties);
}

class AnalyticsEventBuilder with ContextAndSession {
  AnalyticsEvent buildCommonEvent(
      String collectionName, Map<String, dynamic> properties) {
    final event = AnalyticsEvent(collectionName, properties);
    setCommonProperties(event);
    return event;
  }

  void setCommonProperties(AnalyticsEvent event) {
    event.properties['timestamp'] = DateTime.now().millisecondsSinceEpoch;
    event.properties['session_id'] = sessionManager?.sessionId;
    event.properties['device_event_id'] = Uuid().v4();
    event.properties['context_info'] = contextInfo?.toPropertiesMap();
  }

  Map<String, int> getDurationProperties(Duration duration) => {
        'in_minutes': duration.inMinutes,
        'in_seconds': duration.inSeconds,
        'in_milliseconds': duration.inMilliseconds,
      };

  Map<String, double> getProcessMemoryProperties() => {
        'current_rss_in_mb': processCurrentRssInMB,
        'max_rss_in_mb': processMaxRssInMB
      };

  Map<String, dynamic> getCliExitCodeProperties(CliExitCode exitCode) {
    return {
      'code': exitCode.code,
      'description': exitCode.description,
      'is_failure': exitCode.isFailure
    };
  }
}
