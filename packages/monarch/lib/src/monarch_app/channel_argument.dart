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
