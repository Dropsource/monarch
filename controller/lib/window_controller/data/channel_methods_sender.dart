import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';

class ChannelMethodsSender with Log {
  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.finest('sending channel method: $method');
    return MonarchChannels.controller.invokeMethod(method, arguments);
  }

  Future setUpLog(int defaultLogLevelValue) {
    return _invokeMonarchChannelMethod(MonarchMethods.setUpLog,
        {"defaultLogLevelValue": defaultLogLevelValue});
  }
}

final channelMethodsSender = ChannelMethodsSender();
