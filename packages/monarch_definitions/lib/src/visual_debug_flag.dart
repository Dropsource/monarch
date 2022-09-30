class VisualDebugFlag {
  final String name;
  final bool isEnabled;

  VisualDebugFlag({required this.name, required this.isEnabled});
}

class VisualDebugFlags {
  static const slowAnimations = 'slowAnimations';
  static const showGuidelines = 'showGuidelines';
  static const showBaselines = 'showBaselines';
  static const highlightRepaints = 'highlightRepaints';
  static const highlightOversizedImages = 'highlightOversizedImages';
}

class VisualDebugExtensionMethods {
  static const timeDilation = 'ext.flutter.timeDilation';
  static const debugPaint = 'ext.flutter.debugPaint';
  static const debugPaintBaselinesEnabled =
      'ext.flutter.debugPaintBaselinesEnabled';
  static const repaintRainbow = 'ext.flutter.repaintRainbow';
  static const invertOversizedImages = 'ext.flutter.invertOversizedImages';
}

class VisualDebugTimeDilationValues {
  static const disabledValue = 1.0;
  static const enabledValue = 5.0;
}

// class VisualDebugFlagMapper implements StandardMapper<VisualDebugFlag> {
//   @override
//   VisualDebugFlag fromStandardMap(Map<String, dynamic> args) {
//     // TODO: implement fromStandardMap
//     throw UnimplementedError();
//   }

//   @override
//   Map<String, dynamic> toStandardMap(VisualDebugFlag obj) =>
//       {'name': obj.name, 'isEnabled': obj.isEnabled};
// }
