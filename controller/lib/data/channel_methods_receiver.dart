import 'package:flutter/services.dart';
import 'package:monarch_controller/data/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';
import 'package:monarch_controller/data/device_definitions.dart';
import 'package:monarch_controller/data/story_scale_definitions.dart';

import '../../main.dart';
import 'channel_methods_sender.dart';
import 'monarch_data.dart';

final _logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  MonarchChannels.controller.setMethodCallHandler((MethodCall call) async {
    _logger.finest('channel method received: ${call.method}');
    if (call.arguments != null) {
      _logger.finest('with arguments: ${call.arguments}');
    }
    try {
      return await _handler(call);
    } catch (e, s) {
      _logger.severe(
          'exception in flutter runtime while handling channel method', e, s);
      return PlatformException(code: '001', message: e.toString());
    }
  });
}

Future<dynamic> _handler(MethodCall call) async {
  final args =
      call.arguments == null ? null : Map<String, dynamic>.from(call.arguments);

  switch (call.method) {
    case MonarchMethods.defaultTheme:
      final String themeId = args!['themeId'];
      manager.onDefaultThemeChange(themeId);
      break;

    case MonarchMethods.previewReadySignal:
      if (!manager.state.isPreviewReady) {
        manager.onPreviewReady();
        _logger.info('monarch-preview-ready');
      }
      channelMethodsSender.sendReadySignalAck();
      return;

    case MonarchMethods.previewVmServerUri:
      cliGrpcClientInstance.client!.previewVmServerUriChanged(UriInfo(
          scheme: args!['scheme'],
          host: args['host'],
          port: args['port'],
          path: args['path']));
      return;

    case MonarchMethods.deviceDefinitions:
      final deviceDefinitions = getDeviceDefinitions(args!);
      manager.onDeviceDefinitionsChanged(deviceDefinitions);
      return;

    case MonarchMethods.standardThemes:
      final themes = getStandardThemes(args!);
      manager.onStandardThemesChanged(themes);
      return;

    case MonarchMethods.storyScaleDefinitions:
      final scaleDefinitions = getStoryScaleDefinitions(args!);
      manager.onStoryScaleDefinitionsChanged(scaleDefinitions);
      return;

    case MonarchMethods.monarchData:
      final monarchData = MonarchData.fromStandardMap(args!);
      manager.onMonarchDataChanged(monarchData);
      return;

    case MonarchMethods.toggleVisualDebugFlag:
      final name = args!['name'];
      final isEnabled = args['isEnabled'];
      manager.onVisualDebugFlagToggleByVmService(name, isEnabled);
      return;

    case MonarchMethods.getState:
      return manager.state.toStandardMap();

    case MonarchMethods.userMessage:
      cliGrpcClientInstance.client!
          .printUserMessage(UserMessage(message: args!['message']));
      return;

    default:
      _logger.fine('method ${call.method} not implemented');
      return;
  }
}
