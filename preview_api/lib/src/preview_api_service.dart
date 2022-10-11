import 'package:grpc/grpc.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:preview_api/src/selections_state.dart';
import 'channel_methods_sender.dart';
import 'device_definitions.dart';
import 'preview_notifications.dart';
import 'story_scale_definitions.dart';
import 'project_data.dart';

class PreviewApiService extends MonarchPreviewApiServiceBase {
  final ProjectDataManager projectDataManager;
  final SelectionsStateManager selectionsStateManager;
  final PreviewNotifications previewNotifications;
  final ChannelMethodsSender channelMethodsSender;

  PreviewApiService(
    this.projectDataManager,
    this.selectionsStateManager,
    this.previewNotifications,
    this.channelMethodsSender,
  );

  @override
  Future<ReferenceDataInfo> getReferenceData(ServiceCall call, Empty request) =>
      Future.value(ReferenceDataInfo(
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
  Future<ProjectDataInfo> getProjectData(ServiceCall call, Empty request) =>
      Future.value(projectDataManager.projectData.toInfo());

  @override
  Future<SelectionsStateInfo> getSelectionsState(
          ServiceCall call, Empty request) =>
      Future.value(selectionsStateManager.state.toInfo());

  @override
  Future<ReloadResponse> hotReload(ServiceCall call, Empty request) async {
    var result = await channelMethodsSender.hotReload();
    return ReloadResponse(isSuccessful: result);
  }

  @override
  Future<Empty> resetStory(ServiceCall call, Empty request) {
    channelMethodsSender.resetStory();
    selectionsStateManager.update((state) => state.copyWith(storyKey: null));
    return Future.value(Empty());
  }

  @override
  Future<Empty> restartPreview(ServiceCall call, Empty request) {
    channelMethodsSender.restartPreview();
    return Future.value(Empty());
  }

  @override
  Future<Empty> setDevice(ServiceCall call, DeviceInfo request) {
    var device = DeviceInfoMapper().fromInfo(request);
    channelMethodsSender.setActiveDevice(device);
    selectionsStateManager.update((state) => state.copyWith(device: device));
    return Future.value(Empty());
  }

  @override
  Future<Empty> setDock(ServiceCall call, DockInfo request) {
    channelMethodsSender.setDockSide(request.id);
    selectionsStateManager.update(
        (state) => state.copyWith(dock: DockInfoMapper().fromInfo(request)));
    return Future.value(Empty());
  }

  @override
  Future<Empty> setLocale(ServiceCall call, LocaleInfo request) {
    channelMethodsSender.setActiveLocale(request.languageTag);
    selectionsStateManager
        .update((state) => state.copyWith(languageTag: request.languageTag));
    return Future.value(Empty());
  }

  @override
  Future<Empty> setScale(ServiceCall call, ScaleInfo request) {
    channelMethodsSender.setStoryScale(request.scale);
    selectionsStateManager.update(
        (state) => state.copyWith(scale: ScaleInfoMapper().fromInfo(request)));
    return Future.value(Empty());
  }

  @override
  Future<Empty> setStory(ServiceCall call, StoryKeyInfo request) {
    channelMethodsSender.loadStory(request.storyKey);
    selectionsStateManager
        .update((state) => state.copyWith(storyKey: request.storyKey));
    return Future.value(Empty());
  }

  @override
  Future<Empty> setTextScaleFactor(
      ServiceCall call, TextScaleFactorInfo request) {
    channelMethodsSender.setTextScaleFactor(request.scale);
    selectionsStateManager
        .update((state) => state.copyWith(textScaleFactor: request.scale));
    return Future.value(Empty());
  }

  @override
  Future<Empty> setTheme(ServiceCall call, ThemeInfo request) {
    channelMethodsSender.setActiveTheme(request.id);
    selectionsStateManager.update(
        (state) => state.copyWith(theme: ThemeInfoMapper().fromInfo(request)));
    return Future.value(Empty());
  }

  @override
  Future<Empty> toggleVisualDebugFlag(
      ServiceCall call, VisualDebugFlagInfo request) {
    channelMethodsSender.sendToggleVisualDebugFlag(
        VisualDebugFlag(name: request.name, isEnabled: request.isEnabled));

    /// No need to set the selections state here. It will be done in the channel_methods_receiver.
    return Future.value(Empty());
  }

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
