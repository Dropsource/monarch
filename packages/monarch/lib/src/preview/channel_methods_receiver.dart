import 'package:flutter/services.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_channels.dart';

import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'active_locale.dart';
import 'active_text_scale_factor.dart';
import 'active_story_scale.dart';
import 'channel_methods.dart';
import 'ready_signal.dart';
import 'start_monarch_preview.dart' as startup;
import 'stories_errors.dart';
import 'visual_debug_flags.dart' as visual_debug;
import 'vm_service_client.dart';

final _logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  // logger.level = LogLevel.ALL;
  MonarchMethodChannels.preview.setMethodCallHandler((MethodCall call) async {
    _logger.finest('channel method received: ${call.method}');

    try {
      return await _handler(call);
    } catch (e, s) {
      _logger.severe('Exception while handling channel method', e, s);
      return Future.error(e);
    }
  });
}

Future<dynamic> _handler(MethodCall call) async {
  final Map? args = call.arguments;

  switch (call.method) {
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
      await startup.dispose();
      return;

    case MonarchMethods.hotReload:
      var result = await vmServiceClient.hotReload();
      return result;

    default:
      _logger.fine('method ${call.method} not implemented');
      return;
  }
}
