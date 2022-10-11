import 'package:monarch_definitions/monarch_definitions.dart';

class VisualDebugFlagUi extends VisualDebugFlag {
  final String label;
  final String toggled;

  VisualDebugFlagUi({
    required String name,
    required bool isEnabled,
    required this.label,
    required this.toggled,
  }) : super(name: name, isEnabled: isEnabled);

  VisualDebugFlagUi copyWith({bool? enabled}) {
    return VisualDebugFlagUi(
      name: name,
      isEnabled: enabled ?? isEnabled,
      label: label,
      toggled: toggled,
    );
  }
}

/// something like `VisualDebugFlagUi getVisualDebugFlagUi(String flagKey, bool isEnabled)`
/// which the ui calls, so the ui object is generated from the paramters passed in
/// 
/// 

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

final devToolsOptions = [
  VisualDebugFlagUi(
    name: VisualDebugFlags.slowAnimations,
    label: 'dev_tools.slow_animations',
    toggled: 'slow_animations_toggled',
  ),
  VisualDebugFlagUi(
    name: VisualDebugFlags.showGuidelines,
    label: 'dev_tools.show_guideliness',
    toggled: 'show_guidelines_toggled',
  ),
  VisualDebugFlagUi(
    name: VisualDebugFlags.showBaselines,
    label: 'dev_tools.show_baseliness',
    toggled: 'show_baselines_toggled',
  ),
  VisualDebugFlagUi(
    name: VisualDebugFlags.highlightRepaints,
    label: 'dev_tools.highlight_repaints',
    toggled: 'highlight_repaints_toggled',
  ),
  VisualDebugFlagUi(
    name: VisualDebugFlags.highlightOversizedImages,
    label: 'dev_tools.highlight_oversized_images',
    toggled: 'highlight_oversized_images_toggled',
  ),
];
