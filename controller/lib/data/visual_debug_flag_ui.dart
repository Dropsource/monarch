import 'package:monarch_definitions/monarch_definitions.dart';

class VisualDebugFlagUi extends VisualDebugFlag {
  final String label;
  final String toggled;

  VisualDebugFlagUi({
    required String name,
    bool isEnabled = false,
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
