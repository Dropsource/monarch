import 'package:flutter/services.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';
import 'package:monarch_controller/data/device_definitions.dart';
import 'package:monarch_controller/data/story_scale_definitions.dart';

import '../../main.dart';
import 'channel_methods_sender.dart';
import 'monarch_data.dart';

final logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  MonarchChannels.controller.setMethodCallHandler((MethodCall call) async {
    logger.finest('channel method received: ${call.method}');
    if (call.arguments != null) {
      logger.finest('with arguments: ${call.arguments}');
    }
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
      return;

    case MonarchMethods.defaultTheme:
      final String themeId = args!['themeId'];
      manager.onDefaultThemeChange(themeId);
      break;

    case MonarchMethods.readySignal:
      if (manager.state.isReady) {
        logger.info(
            'flutter window had been ready, ready signal means potential reload');
      } else {
        manager.onReady();
      }
      channelMethodsSender.sendReadySignalAck();
      return;

    case MonarchMethods.deviceDefinitions:
      final deviceDefinitions = getDeviceDefinitions(args!);
      manager.onDeviceDefinitionsChanged(deviceDefinitions);
      break;

    case MonarchMethods.standardThemes:
      final themes = getStandardThemes(args!);
      manager.onStandardThemesChanged(themes);
      break;

    case MonarchMethods.storyScaleDefinitions:
      final scaleDefinitions = getStoryScaleDefinitions(args!);
      manager.onStoryScaleDefinitionsChanged(scaleDefinitions);
      break;

    case MonarchMethods.monarchData:
      final monarchData = MonarchData.fromStandardMap(args!);
      manager.onMonarchDataChanged(monarchData);
      break;

    case MonarchMethods.toggleVisualDebugFlag:
      final name = args!['name'];
      final isEnabled = args['isEnabled'];
      manager.onVisualFlagToggle(name, isEnabled);
      return;

    case MonarchMethods.getState:
      return manager.state.toStandardMap();

    default:
      logger.fine('method ${call.method} not implemented');
      return;
  }
}
