import 'package:flutter/services.dart';
import 'package:pedantic/pedantic.dart';

import 'package:dropsource_storybook_utils/log.dart';

import '../device_definitions.dart';
import 'active_story.dart';
import 'channel_methods.dart';
import 'channel_methods_sender.dart';

final logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  // logger.level = LogLevel.ALL;
  Channels.dropsourceStorybookChannel
      .setMethodCallHandler((MethodCall call) async {
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
  final Map args = call.arguments;

  switch (call.method) {
    case MethodNames.setUpLog:
      _setUpLog(args['defaultLogLevelValue']);
      break;

    case MethodNames.requestDeviceDefinitions:
      logEnvironmentInformation(logger, LogLevel.FINE);
      unawaited(
          channelMethodsSender.sendDeviceDefinitions(DeviceDefinitions()));
      break;

    case MethodNames.loadStory:
      final String storyKey = args['storyKey'];
      activeStory.setActiveStory(storyKey);
      break;

    default:
      // return exception to the platform side, do not throw
      return MissingPluginException('method ${call.method} not implemented');
  }
}

void _setUpLog(int defaultLogLevelValue) {
  defaultLogLevel = _getLogLevelFromValue(defaultLogLevelValue);
  logCurrentProcessInformation(logger, LogLevel.FINE);
}

LogLevel _getLogLevelFromValue(int logLevelValue) {
  for (var logLevel in LogLevel.LEVELS) {
    if (logLevel.value == logLevelValue) {
      return logLevel;
    }
  }
  return LogLevel.ALL;
}
