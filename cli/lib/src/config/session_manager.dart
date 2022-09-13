import 'package:monarch_utils/log.dart';
import 'package:uuid/uuid.dart';

/// In the future, this class could manage the sessions used for analytics and
/// crash reporting.
///
/// We can follow the Google Analytics pattern for sessions:
/// https://support.google.com/analytics/answer/2731565?hl=en
class SessionManager with Log {
  SessionManager() {
    log.config('session_id=$sessionId');
  }
  Session session = Session();
  String get sessionId => session.id;
}

class Session {
  final String id = Uuid().v4();
}
