import 'package:flutter/services.dart';

abstract class ChannelArgument {}

// abstract class InboundChannelArgument extends ChannelArgument {
// }

abstract class OutboundChannelArgument extends ChannelArgument {
  /// Implementors should return a map with keys as Strings. If the value
  /// is a list, it should be a list, not an iterable. If you have an
  /// iterable, make sure to use `.toList()` on it.
  /// 
  /// This map is used by the channel's codec [StandardMethodCodec].
  Map<String, dynamic> toStandardMap();
}


class Channels {
  static const dropsourceStorybookChannel = MethodChannel('dropsource.storybook');
}


class MethodNames {
  static const ping = 'dropsource.storybook.ping';
  static const storybookData = 'dropsource.storybook.storybookData';
  static const requestDeviceDefinitions = 'dropsource.storybook.requestDeviceDefinitions';
  static const deviceDefinitions = 'dropsource.storybook.deviceDefinitions';
  static const requestStandardThemes = 'dropsource.storybook.requestStandardThemes';
  static const standardThemes = 'dropsource.storybook.standardThemes';
  static const defaultTheme = 'dropsource.storybook.defaultTheme';
  static const readySignal = 'dropsource.storybook.readySignal';
  static const loadStory = 'dropsource.storybook.loadStory';
  static const setUpLog = 'dropsource.storybook.setUpLog';
  static const setActiveTheme = 'dropsource.storybook.setActiveTheme';
}
