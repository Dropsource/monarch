import 'package:monarch_definitions/monarch_definitions.dart';

String getVisualDebugFlagLabel(String name) {
  switch (name) {
    case VisualDebugFlags.slowAnimations:
      return 'dev_tools.slow_animations';
    case VisualDebugFlags.showGuidelines:
      return 'dev_tools.show_guideliness';
    case VisualDebugFlags.showBaselines:
      return 'dev_tools.show_baseliness';
    case VisualDebugFlags.highlightRepaints:
      return 'dev_tools.highlight_repaints';
    case VisualDebugFlags.highlightOversizedImages:
      return 'dev_tools.highlight_oversized_images';
    default:
      throw 'Unexpected visual debug flag name $name';
  }
}

String getVisualDebugFlagToggledKey(String name) {
  switch (name) {
    case VisualDebugFlags.slowAnimations:
      return 'slow_animations_toggled';
    case VisualDebugFlags.showGuidelines:
      return 'show_guidelines_toggled';
    case VisualDebugFlags.showBaselines:
      return 'show_baselines_toggled';
    case VisualDebugFlags.highlightRepaints:
      return 'highlight_repaints_toggled';
    case VisualDebugFlags.highlightOversizedImages:
      return 'highlight_oversized_images_toggled';
    default:
      throw 'Unexpected visual debug flag name $name';
  }
}
