import 'standard_mapper.dart';

class VisualDebugFlag {
  final String name;
  final bool isEnabled;

  const VisualDebugFlag({required this.name, required this.isEnabled});
}

class VisualDebugFlags {
  static const slowAnimations = 'slowAnimations';
  static const showGuidelines = 'showGuidelines';
  static const showBaselines = 'showBaselines';
  static const highlightRepaints = 'highlightRepaints';
  static const highlightOversizedImages = 'highlightOversizedImages';
  static const performanceOverlay = 'performanceOverlay';
}

const defaultVisualDebugFlags = <String, bool>{
  VisualDebugFlags.slowAnimations: false,
  VisualDebugFlags.showGuidelines: false,
  VisualDebugFlags.showBaselines: false,
  VisualDebugFlags.highlightRepaints: false,
  VisualDebugFlags.highlightOversizedImages: false,
  VisualDebugFlags.performanceOverlay: false,
};

class VisualDebugExtensionMethods {
  static const timeDilation = 'ext.flutter.timeDilation';
  static const debugPaint = 'ext.flutter.debugPaint';
  static const debugPaintBaselinesEnabled = 'ext.flutter.debugPaintBaselinesEnabled';
  static const repaintRainbow = 'ext.flutter.repaintRainbow';
  static const invertOversizedImages = 'ext.flutter.invertOversizedImages';
  static const performanceOverlay = 'ext.flutter.showPerformanceOverlay';
}

class VisualDebugTimeDilationValues {
  static const disabledValue = 1.0;
  static const enabledValue = 5.0;
}

class VisualDebugFlagMapper implements StandardMapper<VisualDebugFlag> {
  @override
  VisualDebugFlag fromStandardMap(Map<String, dynamic> args) =>
      VisualDebugFlag(name: args['name'], isEnabled: args['isEnabled']);

  @override
  Map<String, dynamic> toStandardMap(VisualDebugFlag obj) =>
      {'name': obj.name, 'isEnabled': obj.isEnabled};
}
