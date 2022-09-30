import 'package:monarch/src/preview/stories_errors.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_channels.dart';
import 'active_device.dart';
import 'active_locale.dart';
import 'active_story.dart';
import 'active_story_scale.dart';
import 'active_text_scale_factor.dart';
import 'active_theme.dart';
import 'channel_methods.dart';
import 'visual_debug_flags.dart' as visual_debug;

class ChannelMethodsSender with Log {
  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.finest('sending channel method: $method');
    return MonarchMethodChannels.preview.invokeMethod(method, arguments);
  }

  Future sendPing() {
    return _invokeMonarchChannelMethod(MonarchMethods.ping);
  }

  Future sendDeviceDefinitions(OutboundChannelArgument definitions) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.deviceDefinitions, definitions.toStandardMap());
  }

  Future sendStoryScaleDefinitions(OutboundChannelArgument definitions) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.storyScaleDefinitions, definitions.toStandardMap());
  }

  Future sendStandardThemes(OutboundChannelArgument definitions) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.standardThemes, definitions.toStandardMap());
  }

  Future sendDefaultTheme(String id) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.defaultTheme, {'themeId': id});
  }

  Future sendMonarchData(OutboundChannelArgument monarchData) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.monarchData, monarchData.toStandardMap());
  }

  Future getState() async {
    var state = await _invokeMonarchChannelMethod(MonarchMethods.getState);
    var activeStoryKey = state['activeStoryKey'];
    var deviceId = state['device']['id'];
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
    activeDevice.value = activeDevice.getDeviceDefinition(deviceId);
    activeTextScaleFactor.value = textScaleFactor;
    activeStoryScale.value = scale;
    for (var flag in visualDebugFlags) {
      var name = flag['name'];
      var isEnabled = flag['isEnabled'];
      await visual_debug.toggleFlagViaVmServiceExtension(name, isEnabled);
    }
  }

  Future sendReadySignal() {
    return _invokeMonarchChannelMethod(MonarchMethods.previewReadySignal);
  }

  Future sendPreviewVmServerUri(Uri uri) {
    return _invokeMonarchChannelMethod(MonarchMethods.previewVmServerUri, {
      'scheme': uri.scheme,
      'host': uri.host,
      'port': uri.port,
      'path': uri.path,
    });
  }

  Future sendUserMessage(String message) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.userMessage, {'message': message});
  }

  Future sendToggleVisualDebugFlag(OutboundChannelArgument visualDebugFlag) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.toggleVisualDebugFlag, visualDebugFlag.toStandardMap());
  }
}

final channelMethodsSender = ChannelMethodsSender();
