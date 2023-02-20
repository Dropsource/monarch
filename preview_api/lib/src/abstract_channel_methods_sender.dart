import 'package:monarch_definitions/monarch_definitions.dart';

abstract class AbstractChannelMethodsSender {
  Future sendToggleVisualDebugFlag(VisualDebugFlag visualDebugFlag);

  void sendReadySignalAck();

  void setTextScaleFactor(double scale);

  void setStory(StoryId storyId);

  void resetStory();

  void setActiveLocale(String locale);

  void setActiveTheme(String themeId);

  void setActiveDevice(DeviceDefinition deviceDefinition);

  void setStoryScale(double scale);

  void setDockSide(String dock);

  Future<bool> hotReload();

  void willRestartPreview();

  void restartPreview();

  void terminatePreview();
}
