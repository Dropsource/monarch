import 'package:grpc/grpc.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'channel_methods_sender.dart';
import 'device_definitions.dart';
import 'preview_notifications_api_clients.dart';
import 'story_scale_definitions.dart';

class PreviewApiService extends MonarchPreviewApiServiceBase {
  @override
  Future<ReloadResponse> hotReload(ServiceCall call, Empty request) async {
    var result = await channelMethodsSender.hotReload();
    return ReloadResponse(isSuccessful: result);
  }

  @override
  Future<Empty> resetStory(ServiceCall call, Empty request) {
    channelMethodsSender.resetStory();
    return Future.value(Empty());
  }

  @override
  Future<Empty> restartPreview(ServiceCall call, Empty request) {
    channelMethodsSender.restartPreview();
    return Future.value(Empty());
  }

  @override
  Future<Empty> setDevice(ServiceCall call, DeviceInfo request) {
    channelMethodsSender.setActiveDevice(DeviceDefinition(
        id: request.id,
        name: request.name,
        logicalResolution: LogicalResolution(
            height: request.logicalResolutionInfo.height,
            width: request.logicalResolutionInfo.width),
        devicePixelRatio: request.devicePixelRatio,
        targetPlatform: targetPlatformFromString(request.targetPlatform)));
    return Future.value(Empty());
  }

  @override
  Future<Empty> setDockSide(ServiceCall call, DockSideInfo request) {
    channelMethodsSender.setDockSide(request.dock);
    return Future.value(Empty());
  }

  @override
  Future<Empty> setLocale(ServiceCall call, LocaleInfo request) {
    channelMethodsSender.setActiveLocale(request.languageTag);
    return Future.value(Empty());
  }

  @override
  Future<Empty> setScale(ServiceCall call, ScaleInfo request) {
    channelMethodsSender.setStoryScale(request.scale);
    return Future.value(Empty());
  }

  @override
  Future<Empty> setStory(ServiceCall call, StoryKeyInfo request) {
    channelMethodsSender.loadStory(request.storyKey);
    return Future.value(Empty());
  }

  @override
  Future<Empty> setTextScaleFactor(
      ServiceCall call, TextScaleFactorInfo request) {
    channelMethodsSender.setTextScaleFactor(request.scale);
    return Future.value(Empty());
  }

  @override
  Future<Empty> setTheme(ServiceCall call, ThemeInfo request) {
    channelMethodsSender.setActiveTheme(request.id);
    return Future.value(Empty());
  }

  @override
  Future<Empty> toggleVisualDebugFlag(
      ServiceCall call, VisualDebugFlagInfo request) {
    channelMethodsSender.sendToggleVisualDebugFlag(
        VisualDebugFlag(name: request.name, isEnabled: request.isEnabled));
    return Future.value(Empty());
  }

  @override
  Future<ReferenceDefinitions> getReferenceDefinitions(
          ServiceCall call, Empty request) =>
      Future.value(ReferenceDefinitions(
          devices: deviceDefinitions.map((e) => DeviceInfo(
              id: e.id,
              name: e.name,
              targetPlatform: targetPlatformToString(e.targetPlatform),
              logicalResolutionInfo: LogicalResolutionInfo(
                  height: e.logicalResolution.height,
                  width: e.logicalResolution.width),
              devicePixelRatio: e.devicePixelRatio)),
          standardThemes: standardMetaThemeDefinitions.map(
              (e) => ThemeInfo(id: e.id, name: e.name, isDefault: e.isDefault)),
          scales: storyScaleDefinitions
              .map((e) => ScaleInfo(scale: e.scale, name: e.name))));

  @override
  Future<Empty> launchDevTools(ServiceCall call, Empty request) {
    // DevTools are launched from the cli process since it needs the attach process information.
    // The Preview API forwards this request to all the notification clients. The controller client
    // should do nothing. The cli client should launch DevTools.
    previewNotifications.launchDevTools();
    return Future.value(Empty());
  }

  @override
  Future<Empty> trackUserSelection(
      ServiceCall call, UserSelectionData request) {
    // The Preview API forwards this request to all the notification clients. The controller client
    // should do nothing. The cli client should handle this request.
    previewNotifications.trackUserSelection(request);
    return Future.value(Empty());
  }
}
