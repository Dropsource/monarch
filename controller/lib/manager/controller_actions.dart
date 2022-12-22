import 'dart:async';

import 'package:monarch_grpc/monarch_grpc.dart';
import '../data/visual_debug_flag_utils.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_utils/timers.dart';

/// Handles user actions from the user interface, i.e. callbacks from the widgets.
class ControllerActions {
  final MonarchPreviewApiClient previewApi;

  ControllerActions(this.previewApi);

  Debouncer textScaleFactorDebouncer = Debouncer();

  void onActiveStoryChanged(StoryId storyId) async {
    await previewApi.setStory(StoryIdInfoMapper().toInfo(storyId));
    await previewApi.trackUserSelection(KindInfo(kind: 'story_selected'));
  }

  void onDeviceChanged(DeviceDefinition deviceDefinition) async {
    await previewApi.setDevice(DeviceInfoMapper().toInfo(deviceDefinition));
    await previewApi.trackUserSelection(KindInfo(kind: 'device_selected'));
  }

  void onThemeChanged(MetaThemeDefinition theme) async {
    await previewApi.setTheme(ThemeInfoMapper().toInfo(theme));
    await previewApi.trackUserSelection(KindInfo(kind: 'theme_selected'));
  }

  void onLocaleChanged(String locale) async {
    await previewApi.setLocale(LocaleInfo(languageTag: locale));
    await previewApi.trackUserSelection(KindInfo(kind: 'locale_selected'));
  }

  void onScaleChanged(StoryScaleDefinition scaleDefinition) async {
    await previewApi.setScale(ScaleInfoMapper().toInfo(scaleDefinition));
    await previewApi.trackUserSelection(KindInfo(kind: 'story_scale_selected'));
  }

  void onTextScaleFactorChanged(double val) async {
    await previewApi.setTextScaleFactor(TextScaleFactorInfo(scale: val));
    textScaleFactorDebouncer.debounce(
        const Duration(milliseconds: 250),
        () => previewApi
            .trackUserSelection(KindInfo(kind: 'text_scale_factor_selected')));
  }

  void onDockSettingsChange(DockDefinition dock) async {
    await previewApi.setDock(DockInfoMapper().toInfo(dock));
    await previewApi.trackUserSelection(KindInfo(kind: 'dock_side_selected'));
  }

  /// Called by UI when the user toggles a visual debug checkbox.
  /// It will send a message to the preview api, which calls the preview window
  /// via channel methods, which will call the vm service extension method for
  /// the corresponding flag.
  void onVisualDebugFlagToggledByUi(String flagName, bool isEnabled) async {
    await previewApi.toggleVisualDebugFlag(
        VisualDebugFlagInfo(name: flagName, isEnabled: !isEnabled));

    /// Wait a bit before tracking user selection of visual debug flags.
    /// The preview api doesn't update the state
    /// of the visual debug flags immediately. It relies on the vm service.
    Timer(
        const Duration(milliseconds: 50),
        () => previewApi.trackUserSelection(
            KindInfo(kind: getVisualDebugFlagToggledKey(flagName))));
  }

  void launchDevTools() async {
    await previewApi.launchDevTools(Empty());
    await previewApi
        .trackUserSelection(KindInfo(kind: 'launch_devtools_clicked'));
  }
}
