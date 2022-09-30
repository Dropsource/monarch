import 'package:flutter/services.dart';
import 'package:monarch_definitions/monarch_channels.dart';

class MonarchMethodChannels {
  static const controller = MethodChannel(MonarchChannels.controller);
  static const preview = MethodChannel(MonarchChannels.preview);
}
