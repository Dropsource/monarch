import 'dart:async';
import 'package:monarch_utils/log.dart';

import '../config/context_info.dart';
import '../version_api/version_api.dart';
import '../version_api/notification.dart';

class NotificationsReader with Log {
  final VersionApi api;
  final bool isLocalDeployment;

  NotificationsReader(this.api, this.isLocalDeployment);

  void read(ContextInfo contextInfo) async {
    _completer = Completer();

    if (isLocalDeployment) {
      log.fine('Notifications fetching skipped during local deployment');
      _completer.complete([]);
      return;
    }

    try {
      var timeLimit = Duration(seconds: 5);
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
