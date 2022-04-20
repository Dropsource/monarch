import 'package:flutter/services.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';

import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'active_locale.dart';
import 'active_text_scale_factor.dart';
import 'active_story_scale.dart';
import 'log_level.dart';
import 'ready_signal.dart';
import 'stories_errors.dart';
import 'visual_debug_flags.dart' as visual_debug;

final logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  // logger.level = LogLevel.ALL;
  MonarchChannels.preview.setMethodCallHandler((MethodCall call) async {
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
    case MonarchMethods.setUpLog:
      setDefaultLogLevel(args!['defaultLogLevelValue']);
      logCurrentProcessInformation(logger, LogLevel.FINE);
      break;

    case MonarchMethods.firstLoadSignal:
      logEnvironmentInformation(logger, LogLevel.FINE);
      break;

    case MonarchMethods.readySignalAck:
      readySignal.ready();
      break;

    case MonarchMethods.loadStory:
      String storyKey = args!['storyKey'];
      resetErrors();
      activeStory.value = StoryId.fromNodeKey(storyKey);
      break;

    case MonarchMethods.resetStory:
      resetErrors();
      activeStory.value = null;
      break;

    case MonarchMethods.setActiveLocale:
      String locale = args!['locale'];
      resetErrors();
      activeLocale.setActiveLocaleTag(locale);
      break;

    case MonarchMethods.setActiveTheme:
      String themeId = args!['themeId'];
      resetErrors();
      activeTheme.value = activeTheme.getMetaTheme(themeId);
      break;

    case MonarchMethods.setActiveDevice:
      String deviceId = args!['deviceId'];
      resetErrors();
      activeDevice.value = activeDevice.getDeviceDefinition(deviceId);
      break;

    case MonarchMethods.setTextScaleFactor:
      double factor = args!['factor'];
      resetErrors();
      activeTextScaleFactor.value = factor;
      break;

    case MonarchMethods.setStoryScale:
      double scale = args!['scale'];
      resetErrors();
      activeStoryScale.value = scale;
      break;

    case MonarchMethods.toggleVisualDebugFlag:
      String name = args!['name'];
      bool isEnabled = args['isEnabled'];
      await visual_debug.toggleFlagViaVmServiceExtension(name, isEnabled);
      break;

    default:
      logger.warning('method ${call.method} not implemented');
      // return exception to the platform side, do not throw
      return MissingPluginException('method ${call.method} not implemented');
  }
}
