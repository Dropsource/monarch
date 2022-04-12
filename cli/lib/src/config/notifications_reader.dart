import 'dart:async';
import 'package:monarch_utils/log.dart';

import '../config/context_info.dart';
import '../version_api/version_api.dart';
import '../version_api/notification.dart';
import '../../settings.dart';

class NotificationsReader with Log {
  final VersionApi api;

  NotificationsReader(this.api);

  void read(ContextInfo contextInfo) async {
    _completer = Completer();
    try {
      var timeLimit = DEPLOYMENT == 'production'
          ? Duration(seconds: 5)
          : Duration(seconds: 1);
      var list = await api
          .getNotifications(contextInfo.toPropertiesMap())
          .timeout(timeLimit);
      log.fine('notifications_count=${list.length}');
      _completer.complete(list);
    } catch (e, s) {
      log.warning('Error while fetching notifications', e, s);
      _completer.complete([]);
    }
  }

  late Completer<List<Notification>> _completer;
  Future<List<Notification>> get notifications => _completer.future;
}
