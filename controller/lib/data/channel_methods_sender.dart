import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';

import 'channel_methods.dart';

class ChannelMethodsSender with Log {
  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.finest('sending channel method: $method');

    if (arguments != null) {
      log.finest('with arguments: $arguments');
    }
    return MonarchChannels.controller.invokeMethod(method, arguments);
  }

  Future setUpLog(int defaultLogLevelValue) {
    return _invokeMonarchChannelMethod(MonarchMethods.setUpLog,
        {"defaultLogLevelValue": defaultLogLevelValue});
  }

  Future sendToggleVisualDebugFlag(OutboundChannelArgument visualDebugFlag) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.toggleVisualDebugFlag, visualDebugFlag.toStandardMap());
  }

  void sendFirstLoadSignal() {
    _invokeMonarchChannelMethod(MonarchMethods.firstLoadSignal);
  }

  void sendReadySignalAck() {
    _invokeMonarchChannelMethod(MonarchMethods.readySignalAck);
  }

  void setTextScaleFactor(double scale) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setTextScaleFactor, {'factor': scale});
  }

  void loadStory(String storyKey) {
    _invokeMonarchChannelMethod(
        MonarchMethods.loadStory, {'storyKey': storyKey});
  }

  void resetStory() {
    _invokeMonarchChannelMethod(MonarchMethods.resetStory);
  }

  void setActiveLocale(String locale) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setActiveLocale, {'locale': locale});
  }

  void setActiveTheme(String themeId) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setActiveTheme, {'themeId': themeId});
  }

  void setActiveDevice(String deviceId) {
    _invokeMonarchChannelMethod(
        MonarchMethods.setActiveDevice, {'deviceId': deviceId});
  }

  void setStoryScale(double scale) {
    _invokeMonarchChannelMethod(MonarchMethods.setStoryScale, {'scale': scale});
  }
}

final channelMethodsSender = ChannelMethodsSender();
