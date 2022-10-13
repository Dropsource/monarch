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

  Future sendMonarchData(MonarchDataDefinition monarchData) {
    return _invokeMonarchChannelMethod(MonarchMethods.monarchData,
        MonarchDataDefinitionMapper().toStandardMap(monarchData));
  }

  Future getState() async {
    dynamic stateDynamic =
        await _invokeMonarchChannelMethod(MonarchMethods.getState);
    var stateArgs = Map<String, dynamic>.from(stateDynamic);

    resetErrors();
    if (stateArgs['storyId'] == null) {
      activeStory.value = null;
    } else {
      activeStory.value = StoryIdMapper()
          .fromStandardMap(Map<String, dynamic>.from(stateArgs['storyId']));
    }

    activeDevice.value = DeviceDefinitionMapper()
        .fromStandardMap(Map<String, dynamic>.from(stateArgs['device']));
    activeStoryScale.value = StoryScaleDefinitionMapper()
        .fromStandardMap(Map<String, dynamic>.from(stateArgs['scale']))
        .scale;

    activeLocale.setActiveLocaleTag(stateArgs['locale']);
    activeTheme.value = activeTheme.getMetaTheme(stateArgs['themeId']);
    activeTextScaleFactor.value = stateArgs['textScaleFactor'];

    Map<String, bool>.from(stateArgs['visualDebugFlags']).forEach((name,
            isEnabled) async =>
        await visual_debug.toggleFlagViaVmServiceExtension(name, isEnabled));
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
