import 'package:flutter/services.dart';

class MonarchChannels {
  static const controller = MethodChannel('monarch.controller');
  static const preview = MethodChannel('monarch.preview');
}

class MonarchMethods {
  static const ping = 'monarch.ping';
  static const firstLoadSignal = 'monarch.firstLoadSignal';
  static const readySignalAck = 'monarch.readySignalAck';
  static const monarchData = 'monarch.monarchData';
  static const deviceDefinitions = 'monarch.deviceDefinitions';
  static const storyScaleDefinitions = 'monarch.storyScaleDefinitions';
  static const standardThemes = 'monarch.standardThemes';
  static const defaultTheme = 'monarch.defaultTheme';
  static const readySignal = 'monarch.readySignal';
  static const loadStory = 'monarch.loadStory';
  static const resetStory = 'monarch.resetStory';
  static const setUpLog = 'monarch.setUpLog';
  static const setActiveLocale = 'monarch.setActiveLocale';
  static const setActiveTheme = 'monarch.setActiveTheme';
  static const setActiveDevice = 'monarch.setActiveDevice';
  static const setTextScaleFactor = 'monarch.setTextScaleFactor';
  static const toggleVisualDebugFlag = 'monarch.toggleVisualDebugFlag';
  static const setStoryScale = 'monarch.setStoryScale';
}