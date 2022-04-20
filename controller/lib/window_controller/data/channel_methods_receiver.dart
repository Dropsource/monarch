import 'package:flutter/services.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';
import 'package:monarch_window_controller/window_controller/data/device_definitions.dart';
import 'package:monarch_window_controller/window_controller/window_controller_manager.dart';

import 'channel_methods_sender.dart';

final logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  MonarchChannels.controller.setMethodCallHandler((MethodCall call) async {
    logger.finest('channel method received: ${call.method}');

    try {
      return await _handler(call);
    } catch (e, s) {
      logger.severe(
          'exception in flutter runtime while handling channel method', e, s);
      return PlatformException(code: '001', message: e.toString());
    }
  });
}

Future<dynamic> _handler(MethodCall call) async {
  final args =
      call.arguments == null ? null : Map<String, dynamic>.from(call.arguments);

  switch (call.method) {
    case MonarchMethods.ping:
      channelMethodsSender.setUpLog(LogLevel.ALL.value);
      break;

    case MonarchMethods.deviceDefinitions:
      manager
          .update(manager.state.copyWith(devices: getDeviceDefinitions(args!)));
      break;

    default:
      logger.warning('method ${call.method} not implemented');
      // return exception to the platform side, do not throw
      return MissingPluginException('method ${call.method} not implemented');
  }
}
