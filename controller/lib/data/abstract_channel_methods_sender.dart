import 'channel_methods.dart';

abstract class AbstractChannelMethodsSender {
  Future sendToggleVisualDebugFlag(OutboundChannelArgument visualDebugFlag);

  void sendReadySignalAck();

  void setTextScaleFactor(double scale);

  void loadStory(String storyKey);

  void resetStory();

  void setActiveLocale(String locale);

  void setActiveTheme(String themeId);

  void setActiveDevice(String deviceId);

  void setStoryScale(double scale);

  void setDockSide(String dock);

  Future<bool> hotReload();

  void restartPreview();
}
