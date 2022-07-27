import 'package:flutter/services.dart';

class MonarchChannels {
  static const controller = MethodChannel('monarch.controller');
  static const preview = MethodChannel('monarch.preview');
}

class MonarchMethods {
  static const previewReadySignal = 'monarch.previewReadySignal';
  static const readySignalAck = 'monarch.readySignalAck';
  
  static const monarchData = 'monarch.monarchData';
  static const deviceDefinitions = 'monarch.deviceDefinitions';
  static const storyScaleDefinitions = 'monarch.storyScaleDefinitions';
  static const standardThemes = 'monarch.standardThemes';
  static const defaultTheme = 'monarch.defaultTheme';
  static const loadStory = 'monarch.loadStory';
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

  /// Used when the host window has changed screens, i.e. when the user moves
  /// the host window to a different monitor. Sent by the platform code.
  static const screenChanged = 'monarch.screenChanged';
}
