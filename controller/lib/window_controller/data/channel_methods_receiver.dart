import 'package:flutter/services.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';
import 'package:monarch_window_controller/window_controller/data/device_definitions.dart';
import 'package:monarch_window_controller/window_controller/data/story_scale_definitions.dart';

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
      break;

    case MonarchMethods.defaultTheme:
      manager.update(manager.state.copyWith(
          currentTheme: manager.state.themes
              .firstWhere((element) => element.id == args!['themeId'])));
      break;

    case MonarchMethods.readySignal:
      if (manager.state.active) {
        logger.info(
            'flutter window had been ready, ready signal means potential reload');
      } else {
        manager.update(manager.state.copyWith(active: true));
        //send first load signal
        channelMethodsSender.sendFirstLoadSignal();
        logger.info('story-flutter-window-ready');
      }
      channelMethodsSender.sendReadySignalAck();
      break;

    case MonarchMethods.deviceDefinitions:
      manager
          .update(manager.state.copyWith(devices: getDeviceDefinitions(args!)));
      break;

    case MonarchMethods.standardThemes:
      final themes = manager.state.themes;
      final newThemes = getStandardThemes(args);
      newThemes.where((element) => !themes.contains(element));
      themes.addAll(newThemes);
      manager.update(manager.state.copyWith(themes: newThemes));
      break;

    case MonarchMethods.storyScaleDefinitions:
      manager.update(
          manager.state.copyWith(scaleList: getStoryScaleDefinitions(args!)));
      break;

    case MonarchMethods.monarchData:
      final monarchData = MonarchData.fromStandardMap(args!);
      final allLocales = monarchData.allLocales;
      manager.update(
        manager.state.copyWith(
          monarchData: monarchData,
          themes: manager.state.themes..addAll(monarchData.metaThemes),
          locales: allLocales.isNotEmpty ? allLocales.toList() : null,
          currentLocale: allLocales.isNotEmpty ? allLocales.first : null,
        ),
      );

      if (allLocales.isNotEmpty) {
        channelMethodsSender.setActiveLocale(allLocales.first);
      } else {
        channelMethodsSender.setActiveLocale('en-US');
      }
      channelMethodsSender.setActiveTheme(manager.state.currentTheme.id);
      channelMethodsSender.setActiveDevice(manager.state.currentDevice.id);
      channelMethodsSender.setTextScaleFactor(manager.state.textScaleFactor);
      break;

    case MonarchMethods.toggleVisualDebugFlag:
      final name = args!['name'];
      final isEnabled = args['isEnabled'];
      manager.onVisualFlagToggle(name, isEnabled);
      break;

    default:
      logger.warning('method ${call.method} not implemented');
      // return exception to the platform side, do not throw
      return MissingPluginException('method ${call.method} not implemented');
  }
}
