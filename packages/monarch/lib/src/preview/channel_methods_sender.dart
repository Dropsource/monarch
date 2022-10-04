import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_channels.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'active_device.dart';
import 'active_locale.dart';
import 'active_story.dart';
import 'active_story_scale.dart';
import 'active_text_scale_factor.dart';
import 'active_theme.dart';
import 'channel_methods.dart';
import 'stories_errors.dart';
import 'visual_debug_flags.dart' as visual_debug;

class ChannelMethodsSender with Log {
  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.finest('sending channel method: $method');
    return MonarchMethodChannels.previewWindow.invokeMethod(method, arguments);
  }

  Future sendPing() {
    return _invokeMonarchChannelMethod(MonarchMethods.ping);
  }

  Future sendDeviceDefinitions(List<DeviceDefinition> definitions) {
    return _invokeMonarchChannelMethod(MonarchMethods.deviceDefinitions,
        DeviceDefinitionListMapper().toStandardMap(definitions));
  }

  Future sendStoryScaleDefinitions(List<StoryScaleDefinition> definitions) {
    return _invokeMonarchChannelMethod(MonarchMethods.storyScaleDefinitions,
        StoryScaleDefinitionListMapper().toStandardMap(definitions));
  }

  Future sendStandardThemes(List<MetaThemeDefinition> definitions) {
    return _invokeMonarchChannelMethod(MonarchMethods.standardThemes,
        StandardThemesMapper().toStandardMap(definitions));
  }

  Future sendDefaultTheme(MetaThemeDefinition themeDefinition) {
    return _invokeMonarchChannelMethod(MonarchMethods.defaultTheme,
        MetaThemeDefinitionMapper().toStandardMap(themeDefinition));
  }

  Future sendMonarchData(MonarchDataDefinition monarchData) {
    return _invokeMonarchChannelMethod(MonarchMethods.monarchData,
        MonarchDataDefinitionMapper().toStandardMap(monarchData));
  }

  Future getState() async {
    var state = await _invokeMonarchChannelMethod(MonarchMethods.getState);
    var activeStoryKey = state['activeStoryKey'];
    var deviceArgs = state['device'];
    var themeId = state['themeId'];
    var locale = state['locale'];
    var textScaleFactor = state['textScaleFactor'];
    var scale = state['scale']['scale'];
    var visualDebugFlags = state['visualDebugFlags'];

    resetErrors();
    if (activeStoryKey == null) {
      activeStory.value = null;
    } else {
      activeStory.value = StoryId.fromNodeKey(activeStoryKey);
    }
    activeLocale.setActiveLocaleTag(locale);
    activeTheme.value = activeTheme.getMetaTheme(themeId);
    activeDevice.value = DeviceDefinitionMapper().fromStandardMap(deviceArgs);
    activeTextScaleFactor.value = textScaleFactor;
    activeStoryScale.value = scale;
    for (var flagArgs in visualDebugFlags) {
      var flag = VisualDebugFlagMapper().fromStandardMap(flagArgs);
      await visual_debug.toggleFlagViaVmServiceExtension(
          flag.name, flag.isEnabled);
    }
  }

  Future sendReadySignal() {
    return _invokeMonarchChannelMethod(MonarchMethods.previewReadySignal);
  }

  Future sendPreviewVmServerUri(Uri uri) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.previewVmServerUri, UriMapper().toStandardMap(uri));
  }

  Future sendUserMessage(String message) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.userMessage, {'message': message});
  }

  Future sendToggleVisualDebugFlag(VisualDebugFlag visualDebugFlag) {
    return _invokeMonarchChannelMethod(MonarchMethods.toggleVisualDebugFlag,
        VisualDebugFlagMapper().toStandardMap(visualDebugFlag));
  }
}

final channelMethodsSender = ChannelMethodsSender();
