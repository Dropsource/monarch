import 'package:flutter/services.dart';

import 'package:monarch_utils/log.dart';
import 'channel_methods.dart';

class ChannelMethodsSender with Log {
  final MethodChannel _dropsourceMonarchChannel =
      Channels.dropsourceMonarchChannel;

  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.info('sending channel method: $method');
    return _dropsourceMonarchChannel.invokeMethod(method, arguments);
  }

  Future sendPing() {
    return _invokeMonarchChannelMethod(MethodNames.ping);
  }

  Future sendDeviceDefinitions(OutboundChannelArgument definitions) {
    return _invokeMonarchChannelMethod(
        MethodNames.deviceDefinitions, definitions.toStandardMap());
  }

  Future sendStandardThemes(OutboundChannelArgument definitions) {
    return _invokeMonarchChannelMethod(
        MethodNames.standardThemes, definitions.toStandardMap());
  }

  Future sendDefaultTheme(String id) {
    return _invokeMonarchChannelMethod(
        MethodNames.defaultTheme, {'themeId': id});
  }

  Future sendMonarchData(OutboundChannelArgument monarchData) {
    return _invokeMonarchChannelMethod(
        MethodNames.monarchData, monarchData.toStandardMap());
  }

  Future sendReadySignal() {
    return _invokeMonarchChannelMethod(MethodNames.readySignal);
  }
}

final channelMethodsSender = ChannelMethodsSender();
