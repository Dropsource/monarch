import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_definitions/monarch_channels.dart';
import 'package:monarch_utils/log.dart';

import 'abstract_channel_methods_sender.dart';
import 'channel_methods.dart';

class ChannelMethodsSender with Log implements AbstractChannelMethodsSender {
  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.finest('sending channel method: $method');

    if (arguments != null) {
      log.finest('with arguments: $arguments');
    }
    return MonarchMethodChannels.previewApi.invokeMethod(method, arguments);
  }

  @override
  void sendReadySignalAck() {
    _invokeMonarchChannelMethod(MonarchMethods.readySignalAck);
  }

  @override
  void setStory(StoryId storyId) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setStory, StoryIdMapper().toStandardMap(storyId));
  }

  @override
  void resetStory() {
    _invokeMonarchChannelMethod(MonarchMethods.resetStory);
  }

  @override
  void setTextScaleFactor(double scale) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setTextScaleFactor, {'factor': scale});
  }

  @override
  void setActiveLocale(String locale) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setActiveLocale, {'locale': locale});
  }

  @override
  void setActiveTheme(String themeId) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setActiveTheme, {'themeId': themeId});
  }

  @override
  void setActiveDevice(DeviceDefinition deviceDefinition) {
    _invokeMonarchChannelMethod(MonarchMethods.setActiveDevice,
        DeviceDefinitionMapper().toStandardMap(deviceDefinition));
  }

  @override
  void setStoryScale(double scale) {
    _invokeMonarchChannelMethod(MonarchMethods.setStoryScale, {'scale': scale});
  }

  @override
  void setDockSide(String dock) {
    _invokeMonarchChannelMethod(MonarchMethods.setDockSide, {'dock': dock});
  }

  @override
  Future sendToggleVisualDebugFlag(VisualDebugFlag visualDebugFlag) {
    return _invokeMonarchChannelMethod(MonarchMethods.toggleVisualDebugFlag,
        VisualDebugFlagMapper().toStandardMap(visualDebugFlag));
  }

  @override
  Future<bool> hotReload() async {
    var result = await _invokeMonarchChannelMethod(MonarchMethods.hotReload);
    return result;
  }

  @override
  void restartPreview() {
    _invokeMonarchChannelMethod(MonarchMethods.restartPreview);
  }

  @override
  void terminatePreview() {
    _invokeMonarchChannelMethod(MonarchMethods.terminatePreview);
  }

  @override
  void willRestartPreview() {
    _invokeMonarchChannelMethod(MonarchMethods.willRestartPreview);
  }
}
