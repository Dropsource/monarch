import 'package:flutter/services.dart';
import 'package:monarch_controller/data/grpc.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_channels.dart';
import 'package:preview_api/src/preview_notifications_api_clients.dart';

import '../data/device_definitions.dart';
import '../data/story_scale_definitions.dart';

import '../../main.dart';
import 'channel_methods_sender.dart';
import 'channel_methods.dart';
import 'monarch_data.dart';

final _logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  MonarchMethodChannels.previewApi
      .setMethodCallHandler((MethodCall call) async {
    _logger.finest('channel method received: ${call.method}');
    // if (call.arguments != null) {
    //   _logger.finest('with arguments: ${call.arguments}');
    // }
    try {
      return await _handler(call);
    } catch (e, s) {
      _logger.severe('Exception while handling channel method', e, s);
      return Future.error(e);
    }
  });
}

bool _isPreviewReady = false;

/// THIS USED TO BE IN THE CONTROLLLER
Future<dynamic> _handler(MethodCall call) async {
  final args =
      call.arguments == null ? null : Map<String, dynamic>.from(call.arguments);

  switch (call.method) {
    case MonarchMethods.ping:
      return true;

    case MonarchMethods.previewReadySignal:
      if (!_isPreviewReady) {
        _logger.info('monarch-preview-ready');
        _isPreviewReady = true;
      }
      previewNotifications.previewReady();
      channelMethodsSender.sendReadySignalAck();

      /// Already moved to controller. The controller is managing its own state. For now
      /// send preview-ready signal to all clients, preview_api will keep its own state, see how it goes.
      /// @TODO: remove comment above and commented out code below

      // if (!manager.state.isPreviewReady) {
      //   manager.onPreviewReady();
      //   _logger.info('monarch-preview-ready');
      // }
      // channelMethodsSender.sendReadySignalAck();
      return;

    case MonarchMethods.defaultTheme:
      var theme = MetaThemeDefinitionMapper().fromStandardMap(args!);
      previewNotifications.defaultTheme(theme);
      return;

    case MonarchMethods.previewVmServerUri:
      var uri = UriMapper().fromStandardMap(args!);
      previewNotifications.vmServerUri(uri);
      return;

    case MonarchMethods.monarchData:
      final monarchData = MonarchDataDefinitionMapper().fromStandardMap(args!);
      previewNotifications.projectPackage(monarchData.packageName);
      previewNotifications.projectStories(monarchData.metaStoriesDefinitionMap);
      previewNotifications.projectThemes(monarchData.metaThemeDefinitions);
      previewNotifications.projectLocales(monarchData.metaLocalizationDefinitions);
      // manager.onMonarchDataChanged(monarchData);
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
