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
  ) {
    selectionsStateManager.stream
        .listen((state) => previewNotifications.selectionsStateChanged(state));

    projectDataManager.stream.listen((projectData) {
      previewNotifications.projectDataChanged(projectData);
      var state = selectionsStateManager.state;

      void checkStory() {
        if (state.storyId != null && !projectData.hasStory(state.storyId!)) {
          _resetStory();
        }
      }

      void checkTheme() {
        var themes = standardMetaThemeDefinitions + projectData.projectThemes;
        if (!themes.any(
            (element) => element.id == state.theme.id)) {
          for (var theme in projectData.projectThemes) {
            if (theme.isDefault) {
              _setTheme(theme);
              return;
            }
          }
          for (var theme in standardMetaThemeDefinitions) {
            if (theme.isDefault) {
              _setTheme(theme);
              return;
            }
          }
        }
      }

      void checkLocale() {
        if (!projectData.allLocaleLanguageTags
            .contains(state.languageTag)) {
          if (projectData.allLocaleLanguageTags.isEmpty) {
            _setLocale(defaultLocale);
          } else {
            _setLocale(projectData.allLocaleLanguageTags.first);
          }
        }
      }

      checkStory();
      checkTheme();
      checkLocale();
    });
  }

  @override
  Future<ReferenceDataInfo> getReferenceData(ServiceCall call, Empty request) =>
      Future.value(ReferenceDataInfo(
          devices: deviceDefinitions.map((e) => DeviceInfoMapper().toInfo(e)),
          standardThemes: standardMetaThemeDefinitions
              .map((e) => ThemeInfoMapper().toInfo(e)),
          scales:
              storyScaleDefinitions.map((e) => ScaleInfoMapper().toInfo(e))));

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
  Future<Empty> setStory(ServiceCall call, StoryIdInfo request) {
    var storyId = StoryIdInfoMapper().fromInfo(request);
    channelMethodsSender.setStory(storyId);
    selectionsStateManager.update((state) => state.copyWith(storyId: storyId));
    return Future.value(Empty());
  }

  @override
  Future<Empty> resetStory(ServiceCall call, Empty request) {
    _resetStory();
    return Future.value(Empty());
  }

  void _resetStory() {
    channelMethodsSender.resetStory();
    selectionsStateManager.update((state) => state.copyWith(storyId: null));
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
    selectionsStateManager.update(
        (state) => state.copyWith(dock: DockInfoMapper().fromInfo(request)));
    channelMethodsSender.setDockSide(request.id);
    return Future.value(Empty());
  }

  @override
  Future<Empty> setLocale(ServiceCall call, LocaleInfo request) {
    _setLocale(request.languageTag);
    return Future.value(Empty());
  }

  void _setLocale(String languageTag) {
    channelMethodsSender.setActiveLocale(languageTag);
    selectionsStateManager
        .update((state) => state.copyWith(languageTag: languageTag));
  }

  @override
  Future<Empty> setScale(ServiceCall call, ScaleInfo request) {
    channelMethodsSender.setStoryScale(request.scale);
    selectionsStateManager.update(
        (state) => state.copyWith(scale: ScaleInfoMapper().fromInfo(request)));
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
    _setTheme(ThemeInfoMapper().fromInfo(request));
    return Future.value(Empty());
  }

  void _setTheme(MetaThemeDefinition theme) {
    channelMethodsSender.setActiveTheme(theme.id);
    selectionsStateManager.update((state) => state.copyWith(theme: theme));
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
