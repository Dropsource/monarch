import 'package:flutter/services.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_channels.dart';

import 'preview_notifications.dart';
import 'project_data.dart';
import 'channel_methods_sender.dart';
import 'channel_methods.dart';
import 'selections_state.dart';

class ChannelMethodsReceiver with Log {
  final ProjectDataManager projectDataManager;
  final SelectionsStateManager selectionsStateManager;
  final PreviewNotifications previewNotifications;
  final ChannelMethodsSender channelMethodsSender;

  ChannelMethodsReceiver(
    this.projectDataManager,
    this.selectionsStateManager,
    this.previewNotifications,
    this.channelMethodsSender,
  );

  void setUp() {
    MonarchMethodChannels.previewApi
        .setMethodCallHandler((MethodCall call) async {
      log.finest('channel method received: ${call.method}');
      if (call.arguments != null) {
        log.finest('with arguments: ${call.arguments}');
      }
      try {
        return await _handler(call);
      } catch (e, s) {
        log.severe('Exception while handling channel method', e, s);
        return Future.error(e);
      }
    });
  }

  bool _isPreviewReady = false;

  Future<dynamic> _handler(MethodCall call) async {
    final args = call.arguments == null
        ? null
        : Map<String, dynamic>.from(call.arguments);

    switch (call.method) {
      case MonarchMethods.ping:
        return true;

      case MonarchMethods.previewReadySignal:
        if (!_isPreviewReady) {
          log.info('monarch-preview-ready');
          _isPreviewReady = true;
        }
        channelMethodsSender.sendReadySignalAck();
        return;

      case MonarchMethods.previewVmServerUri:
        var uri = UriMapper().fromStandardMap(args!);
        previewNotifications.vmServerUri(uri);
        return;

      case MonarchMethods.projectData:
        final projectData =
            ProjectDataDefinitionMapper().fromStandardMap(args!);
        projectDataManager.update(ProjectData(
            packageName: projectData.packageName,
            storiesMap: projectData.metaStoriesDefinitionMap,
            themes: projectData.metaThemeDefinitions,
            localizations: projectData.metaLocalizationDefinitions));
        return;

      /// Sent by the preview's vm-service-client via the method channels.
      /// Sent after a visual debug flag is set via vm service extension methods in the preview.
      /// Thus, we set the selections state in this function.
      /// It is also called after the user sets a visual debug flag using DevTools.
      case MonarchMethods.toggleVisualDebugFlag:
        var flag = VisualDebugFlagMapper().fromStandardMap(args!);
        selectionsStateManager.update((state) {
          var map = Map.of(state.visualDebugFlags);
          map[flag.name] = flag.isEnabled;
          return state.copyWith(visualDebugFlags: map);
        });
        return;

      case MonarchMethods.userMessage:
        previewNotifications
            .userMessage(UserMessageInfo(message: args!['message']));
        return;

      case MonarchMethods.getState:
        return selectionsStateManager.state.toStandardMap();

      default:
        log.fine('method ${call.method} not implemented');
        return;
    }
  }
}
