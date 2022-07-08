import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';

import 'abstract_channel_methods_sender.dart';
import 'channel_methods.dart';

class ChannelMethodsSender with Log implements AbstractChannelMethodsSender {
  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.finest('sending channel method: $method');

    if (arguments != null) {
      log.finest('with arguments: $arguments');
    }
    return MonarchChannels.controller.invokeMethod(method, arguments);
  }

  @override
  Future setUpLog(int defaultLogLevelValue) {
    return _invokeMonarchChannelMethod(MonarchMethods.setUpLog,
        {"defaultLogLevelValue": defaultLogLevelValue});
  }

  @override
  Future sendToggleVisualDebugFlag(OutboundChannelArgument visualDebugFlag) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.toggleVisualDebugFlag, visualDebugFlag.toStandardMap());
  }

  @override
  void sendFirstLoadSignal() {
    _invokeMonarchChannelMethod(MonarchMethods.firstLoadSignal);
  }

  @override
  void sendReadySignalAck() {
    _invokeMonarchChannelMethod(MonarchMethods.readySignalAck);
  }

  @override
  void setTextScaleFactor(double scale) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setTextScaleFactor, {'factor': scale});
  }

  @override
  void loadStory(String storyKey) {
    _invokeMonarchChannelMethod(
        MonarchMethods.loadStory, {'storyKey': storyKey});
  }

  @override
  void resetStory() {
    _invokeMonarchChannelMethod(MonarchMethods.resetStory);
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
  void setActiveDevice(String deviceId) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setActiveDevice, {'deviceId': deviceId});
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
  Future<bool> hotReload() async {
    var result = await _invokeMonarchChannelMethod(MonarchMethods.hotReload);
    return result;
  }
  
  @override
  void restartPreview() {
    _invokeMonarchChannelMethod(MonarchMethods.restartPreview);
  }

}

final channelMethodsSender = ChannelMethodsSender();
