class MonarchChannels {
  static const previewApi = 'monarch.previewApi';
  static const previewWindow = 'monarch.previewWindow';
}

class MonarchMethods {
  static const ping = "monarch.ping";
  static const previewReadySignal = 'monarch.previewReadySignal';
  static const readySignalAck = 'monarch.readySignalAck';

  static const monarchData = 'monarch.monarchData';
  static const setStory = 'monarch.setStory';
  static const resetStory = 'monarch.resetStory';
  static const setActiveLocale = 'monarch.setActiveLocale';
  static const setActiveTheme = 'monarch.setActiveTheme';
  static const setActiveDevice = 'monarch.setActiveDevice';
  static const setTextScaleFactor = 'monarch.setTextScaleFactor';
  static const toggleVisualDebugFlag = 'monarch.toggleVisualDebugFlag';
  static const setStoryScale = 'monarch.setStoryScale';
  static const setDockSide = 'monarch.setDockSide';
  static const getState = 'monarch.getState';
  static const willClosePreview = 'monarch.willClosePreview';
  static const hotReload = 'monarch.hotReload';
  static const restartPreview = 'monarch.restartPreview';
  static const previewVmServerUri = 'monarch.previewVmServerUri';
  static const userMessage = 'monarch.userMessage';
  static const terminatePreview = 'monarch.terminatePreview';

  /// Used when the host window has changed screens, i.e. when the user moves
  /// the host window to a different monitor. Sent by the platform code.
  static const screenChanged = 'monarch.screenChanged';
}
