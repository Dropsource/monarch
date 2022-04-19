import 'package:flutter/services.dart';

abstract class ChannelArgument {}

abstract class OutboundChannelArgument extends ChannelArgument {
  /// Implementors should return a map with keys as Strings. If the value
  /// is a list, it should be a list, not an iterable. If you have an
  /// iterable, make sure to use `.toList()` on it.
  ///
  /// This map is used by the channel's codec [StandardMethodCodec].
  Map<String, dynamic> toStandardMap();
}

class Channels {
  static const controllerChannel = MethodChannel('monarch.controller');
}

class MethodNames {
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
