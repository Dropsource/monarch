import 'package:flutter/services.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'active_locale.dart';
import 'active_text_scale_factor.dart';
import 'active_story_scale.dart';
import 'channel_methods.dart';
import 'ready_signal.dart';
import 'visual_debug_flags.dart' as visual_debug;

final logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  // logger.level = LogLevel.ALL;
  Channels.dropsourceMonarchChannel
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
  final Map? args = call.arguments;

  switch (call.method) {
    case MethodNames.setUpLog:
      _setUpLog(args!['defaultLogLevelValue']);
      break;

    case MethodNames.firstLoadSignal:
      logEnvironmentInformation(logger, LogLevel.FINE);
      break;

    case MethodNames.readySignalAck:
      readySignal.ready();
      break;

    case MethodNames.loadStory:
      String storyKey = args!['storyKey'];
      activeStory.value = StoryId.fromNodeKey(storyKey);
      break;

    case MethodNames.setActiveLocale:
      String locale = args!['locale'];
      activeLocale.setActiveLocaleTag(locale);
      break;

    case MethodNames.setActiveTheme:
      String themeId = args!['themeId'];
      activeTheme.value = activeTheme.getMetaTheme(themeId);
      break;

    case MethodNames.setActiveDevice:
      String deviceId = args!['deviceId'];
      activeDevice.value = activeDevice.getDeviceDefinition(deviceId);
      break;

    case MethodNames.setTextScaleFactor:
      double factor = args!['factor'];
      activeTextScaleFactor.value = factor;
      break;

    case MethodNames.setStoryScale:
      double scale = args!['scale'];
      activeStoryScale.value = scale;
      break;

    case MethodNames.toggleVisualDebugFlag:
      String name = args!['name'];
      bool isEnabled = args['isEnabled'];
      await visual_debug.toggleFlagViaVmServiceExtension(name, isEnabled);
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
