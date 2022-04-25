import 'package:monarch_utils/log.dart';

import 'channel_methods.dart';

class VisualDebugFlag implements OutboundChannelArgument {
  final String name;
  final String label;
  final bool isEnabled;

  VisualDebugFlag({required this.name,  this.isEnabled = false, required this.label});

  @override
  Map<String, dynamic> toStandardMap() {
    return {'name': name, 'isEnabled': isEnabled};
  }

  VisualDebugFlag copyWith({bool? enabled}) {
    return VisualDebugFlag(name: name, isEnabled: enabled ?? isEnabled, label: label);
  }
}

class Flags {
  static const slowAnimations = 'slowAnimations';
  static const showGuidelines = 'showGuidelines';
  static const showBaselines = 'showBaselines';
  static const highlightRepaints = 'highlightRepaints';
  static const highlightOversizedImages = 'highlightOversizedImages';
}

class ExtensionMethods {
  static const timeDilation = 'ext.flutter.timeDilation';
  static const debugPaint = 'ext.flutter.debugPaint';
  static const debugPaintBaselinesEnabled =
      'ext.flutter.debugPaintBaselinesEnabled';
  static const repaintRainbow = 'ext.flutter.repaintRainbow';
  static const invertOversizedImages = 'ext.flutter.invertOversizedImages';
}
