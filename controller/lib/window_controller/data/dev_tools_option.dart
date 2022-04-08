class DevToolsOption {
  final String label;
  final DevToolFeature feature;

  DevToolsOption({
    required this.label,
    required this.feature,
  });
}

enum DevToolFeature {
  slowAnimations,
  highlightRepaints,
  showGuidelines,
  highlightOversizedImages,
  showBaselines,
}
