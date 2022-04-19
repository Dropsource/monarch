import 'package:flutter/services.dart';

import 'package:monarch_utils/log.dart';
import 'channel_methods.dart';

class ChannelMethodsSender with Log {
  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.finest('sending channel method: $method');
    return Channels.controllerChannel.invokeMethod(method, arguments);
  }

  Future setUpLog(int defaultLogLevelValue) {
    return _invokeMonarchChannelMethod(
        MethodNames.setUpLog, {"defaultLogLevelValue": defaultLogLevelValue});
  }
}

final channelMethodsSender = ChannelMethodsSender();