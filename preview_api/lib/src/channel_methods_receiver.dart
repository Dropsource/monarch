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

    log.shout(args.runtimeType);

    switch (call.method) {
      case MonarchMethods.ping:
        return true;

      case MonarchMethods.previewReadySignal:
        if (!_isPreviewReady) {
          log.info('monarch-preview-ready');
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

      // @TODO: remove? questionable why we need to pass defaultTheme
      // case MonarchMethods.defaultTheme:
      //   var theme = MetaThemeDefinitionMapper().fromStandardMap(args!);
      //   previewNotifications.defaultTheme(theme);
      //   return;

      case MonarchMethods.previewVmServerUri:
        var uri = UriMapper().fromStandardMap(args!);
        previewNotifications.vmServerUri(uri);
        return;

      case MonarchMethods.monarchData:
        final monarchData =
            MonarchDataDefinitionMapper().fromStandardMap(args!);
        projectDataManager.update(ProjectData(
            packageName: monarchData.packageName,
            storiesMap: monarchData.metaStoriesDefinitionMap,
            projectThemes: monarchData.metaThemeDefinitions,
            localizations: monarchData.metaLocalizationDefinitions));
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
