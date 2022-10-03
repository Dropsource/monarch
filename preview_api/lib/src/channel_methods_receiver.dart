import 'package:flutter/services.dart';
import 'package:monarch_controller/data/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_channels.dart';

import '../data/device_definitions.dart';
import '../data/story_scale_definitions.dart';

import '../../main.dart';
import 'channel_methods_sender.dart';
import 'channel_methods.dart';
import 'monarch_data.dart';

final _logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  MonarchMethodChannels.previewServer.setMethodCallHandler((MethodCall call) async {
    _logger.finest('channel method received: ${call.method}');
    if (call.arguments != null) {
      _logger.finest('with arguments: ${call.arguments}');
    }
    try {
      return await _handler(call);
    } catch (e, s) {
      _logger.severe('Exception while handling channel method', e, s);
      return Future.error(e);
    }
  });
}

Future<dynamic> _handler(MethodCall call) async {
  final args =
      call.arguments == null ? null : Map<String, dynamic>.from(call.arguments);

  switch (call.method) {
    case MonarchMethods.ping:
      return true;

    case MonarchMethods.previewReadySignal:
      /// @TODO: not sure if this is needed, the controller will be launch after preview,
      /// it may be suspicious. we already have ping. this may be for reloads, see how it flows
      /// then decide.
      if (!manager.state.isPreviewReady) {
        manager.onPreviewReady();
        _logger.info('monarch-preview-ready');
      }
      channelMethodsSender.sendReadySignalAck();
      return;

    case MonarchMethods.defaultTheme:
      final String themeId = args!['themeId'];
      manager.onDefaultThemeChange(themeId);
      return;

    case MonarchMethods.previewVmServerUri:
    /// @TODO: the preview server should send data to all clients, not just the cli,
    /// it should not depend on the cli grpc client, some clients may choose to do nothing on 
    /// specific grpc calls
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
