import 'package:flutter/services.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';
import 'package:monarch_window_controller/window_controller/data/device_definitions.dart';
import 'package:monarch_window_controller/window_controller/data/story_scale_definitions.dart';
import 'package:monarch_window_controller/window_controller/window_controller_manager.dart';

import '../../main.dart';
import 'channel_methods_sender.dart';
import 'monarch_data.dart';

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

  logger.info('Received method call: ${call.method}');
  logger.info('Method data: ${args.toString()}');

  print('test');

  switch (call.method) {
    case MonarchMethods.ping:
      channelMethodsSender.setUpLog(LogLevel.ALL.value);
      break;

    case MonarchMethods.deviceDefinitions:
      manager
          .update(manager.state.copyWith(devices: getDeviceDefinitions(args!)));
      break;

    case MonarchMethods.readySignal:
      manager.update(manager.state.copyWith(active: true));
      break;

    case MonarchMethods.standardThemes:
      // manager.up
      //todo merge themes with monarch data
      //todo move to manager
      final themes = manager.state.themes;
      final newThemes = getStandardThemes(args);
      newThemes.where((element) => !themes.contains(element));
      themes.addAll(newThemes);
      manager.update(manager.state.copyWith(themes: newThemes));
      break;
    case MonarchMethods.defaultTheme:
      //todo: Method data: {themeId: __material-light-theme__}
      manager.update(manager.state.copyWith(
          currentTheme: manager.state.themes
              .firstWhere((element) => element.id == args!['themeId'])));
      break;

    case MonarchMethods.storyScaleDefinitions:
      manager.update(
          manager.state.copyWith(scaleList: getStoryScaleDefinitions(args!)));
      break;

    case MonarchMethods.monarchData:
      manager.update(manager.state
          .copyWith(monarchData: MonarchData.fromStandardMap(args!)));
      break;

    default:
      logger.warning('method ${call.method} not implemented');
      // return exception to the platform side, do not throw
      return MissingPluginException('method ${call.method} not implemented');
  }
}
