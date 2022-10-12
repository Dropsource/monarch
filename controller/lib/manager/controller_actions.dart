import 'package:monarch_grpc/monarch_grpc.dart';
import '../data/visual_debug_flag_utils.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

import 'controller_state.dart';

/// Handles user actions from the user interface, i.e. callbacks from the widgets.
class ControllerActions {
  final MonarchPreviewApiClient previewApi;
  final ControllerState state;

  ControllerActions(this.previewApi, this.state);

  void onActiveStoryChanged(StoryId storyId) async {
    previewApi.setStory(StoryIdInfoMapper().toInfo(storyId));
    _userSelection('story_selected');
  }

  void onDeviceChanged(DeviceDefinition deviceDefinition) {
    previewApi.setDevice(DeviceInfoMapper().toInfo(deviceDefinition));
    _userSelection('device_selected');
  }

  void onThemeChanged(MetaThemeDefinition theme) {
    previewApi.setTheme(ThemeInfoMapper().toInfo(theme));
    _userSelection('theme_selected');
  }

  void onLocaleChanged(String locale) {
    previewApi.setLocale(LocaleInfo(languageTag: locale));
    _userSelection('locale_selected');
  }

  void onScaleChanged(StoryScaleDefinition scaleDefinition) {
    previewApi.setScale(ScaleInfoMapper().toInfo(scaleDefinition));
    _userSelection('story_scale_selected');
  }

  void onTextScaleFactorChanged(double val) {
    previewApi.setTextScaleFactor(TextScaleFactorInfo(scale: val));
    _userSelection('text_scale_factor_selected');
  }

  void onDockSettingsChange(DockDefinition dock) {
    previewApi.setDock(DockInfoMapper().toInfo(dock));
    _userSelection('dock_side_selected');
  }

  /// Called by UI when the user toggles a visual debug checkbox.
  /// It will send a message to the preview api, which calls the preview window
  /// via channel methods, which will call the vm service extension method for
  /// the corresponding flag.
  void onVisualDebugFlagToggledByUi(String flagName, bool isEnabled) {
    previewApi.toggleVisualDebugFlag(
        VisualDebugFlagInfo(name: flagName, isEnabled: !isEnabled));
    _userSelection(getVisualDebugFlagToggledKey(flagName));
  }

  void launchDevTools() {
    previewApi.launchDevTools(Empty());
    _userSelection('launch_devtools_clicked');
  }

  void _userSelection(String kind) {
    previewApi.trackUserSelection(UserSelectionData(
      kind: kind,
      localeCount: state.locales.length,
      userThemeCount: state.userThemes.length,
      storyCount: state.storyCount,
      selectedDevice: state.currentDevice.id,
      selectedTextScaleFactor: state.textScaleFactor,
      selectedStoryScale: state.currentScale.scale,
      selectedDockSide: state.currentDock.id,
      slowAnimationsEnabled:
          state.visualDebugFlags[VisualDebugFlags.slowAnimations],
      highlightRepaintsEnabled:
          state.visualDebugFlags[VisualDebugFlags.highlightRepaints],
      showGuidelinesEnabled:
          state.visualDebugFlags[VisualDebugFlags.showGuidelines],
      highlightOversizedImagesEnabled:
          state.visualDebugFlags[VisualDebugFlags.highlightOversizedImages],
      showBaselinesEnabled:
          state.visualDebugFlags[VisualDebugFlags.showBaselines],
    ));
  }
}