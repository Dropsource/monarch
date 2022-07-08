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
import 'vm_service_client.dart';

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
      return;

    case MonarchMethods.firstLoadSignal:
      logEnvironmentInformation(logger, LogLevel.FINE);
      return;

    case MonarchMethods.readySignalAck:
      readySignal.ready();
      return;

    case MonarchMethods.loadStory:
      String storyKey = args!['storyKey'];
      resetErrors();
      activeStory.value = StoryId.fromNodeKey(storyKey);
      return;

    case MonarchMethods.resetStory:
      resetErrors();
      activeStory.value = null;
      return;

    case MonarchMethods.setActiveLocale:
      String locale = args!['locale'];
      resetErrors();
      activeLocale.setActiveLocaleTag(locale);
      return;

    case MonarchMethods.setActiveTheme:
      String themeId = args!['themeId'];
      resetErrors();
      activeTheme.value = activeTheme.getMetaTheme(themeId);
      return;

    case MonarchMethods.setActiveDevice:
      String deviceId = args!['deviceId'];
      resetErrors();
      activeDevice.value = activeDevice.getDeviceDefinition(deviceId);
      return;

    case MonarchMethods.screenChanged:
      // force the monarch binding to recalculate the physical size.
      activeDevice.value = activeDevice.value;
      return;

    case MonarchMethods.setTextScaleFactor:
      double factor = args!['factor'];
      resetErrors();
      activeTextScaleFactor.value = factor;
      return;

    case MonarchMethods.setStoryScale:
      double scale = args!['scale'];
      resetErrors();
      activeStoryScale.value = scale;
      return;

    case MonarchMethods.toggleVisualDebugFlag:
      String name = args!['name'];
      bool isEnabled = args['isEnabled'];
      await visual_debug.toggleFlagViaVmServiceExtension(name, isEnabled);
      return;

    case MonarchMethods.willClosePreview:
      await vmServiceClient.disconnect();
      return;

    case MonarchMethods.hotReload:
      var result = await vmServiceClient.hotReload();
      return result;

    default:
      logger.fine('method ${call.method} not implemented');
      return;
  }
}
