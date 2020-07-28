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
  static const dropsourceMonarchChannel = MethodChannel('dropsource.monarch');
}

class MethodNames {
  static const ping = 'dropsource.monarch.ping';
  static const firstLoadSignal = 'dropsource.monarch.firstLoadSignal';
  static const readySignalAck = 'dropsource.monarch.readySignalAck';
  static const monarchData = 'dropsource.monarch.monarchData';
  static const deviceDefinitions = 'dropsource.monarch.deviceDefinitions';
  static const standardThemes = 'dropsource.monarch.standardThemes';
  static const defaultTheme = 'dropsource.monarch.defaultTheme';
  static const readySignal = 'dropsource.monarch.readySignal';
  static const loadStory = 'dropsource.monarch.loadStory';
  static const setUpLog = 'dropsource.monarch.setUpLog';
  static const setActiveLocale = 'dropsource.monarch.setActiveLocale';
  static const setActiveTheme = 'dropsource.monarch.setActiveTheme';
  static const setActiveDevice = 'dropsource.monarch.setActiveDevice';
}
