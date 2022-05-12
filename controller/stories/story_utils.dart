import 'package:monarch_controller/data/abstract_channel_methods_sender.dart';
import 'package:monarch_controller/data/channel_methods.dart';

final mockChannelMethodsSender = MockChannelMethodsSender();

class MockChannelMethodsSender implements AbstractChannelMethodsSender {
  @override
  void loadStory(String storyKey) {}

  @override
  void resetStory() {}

  @override
  void sendFirstLoadSignal() {}

  @override
  void sendReadySignalAck() {}

  @override
  Future sendToggleVisualDebugFlag(OutboundChannelArgument visualDebugFlag) => Future.value();

  @override
  void setActiveDevice(String deviceId) {}

  @override
  void setActiveLocale(String locale) {}

  @override
  void setActiveTheme(String themeId) {}

  @override
  void setDockSide(String dock) {}

  @override
  void setStoryScale(double scale) {}

  @override
  void setTextScaleFactor(double scale) {}

  @override
  Future setUpLog(int defaultLogLevelValue) => Future.value();
}
