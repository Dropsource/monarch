import 'package:monarch_utils/log.dart';
import 'package:monarch_channels/monarch_channels.dart';
import 'channel_argument.dart';

class ChannelMethodsSender with Log {
  Future<T?> _invokeMonarchChannelMethod<T>(String method,
      [dynamic arguments]) async {
    log.finest('sending channel method: $method');
    return MonarchChannels.preview.invokeMethod(method, arguments);
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

  Future sendReadySignal() {
    return _invokeMonarchChannelMethod(MonarchMethods.readySignal);
  }

  Future sendToggleVisualDebugFlag(OutboundChannelArgument visualDebugFlag) {
    return _invokeMonarchChannelMethod(
        MonarchMethods.toggleVisualDebugFlag, visualDebugFlag.toStandardMap());
  }
}

final channelMethodsSender = ChannelMethodsSender();
