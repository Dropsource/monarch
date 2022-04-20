class StoryScaleDefinition {
  const StoryScaleDefinition({required this.scale, required this.name});

  final double scale;
  final String name;

  static StoryScaleDefinition fromStandardMap(Map<String, dynamic> args) {
    return StoryScaleDefinition(scale: args['scale'], name: args['name']);
  }
}

List<StoryScaleDefinition> getStoryScaleDefinitions(Map<String, dynamic> args) {
  var defsArgs = args['definitions'] as List<Map<String, dynamic>>;
  return defsArgs.map((e) => StoryScaleDefinition.fromStandardMap(e)).toList();
}

const defaultScaleDefinition = StoryScaleDefinition(scale: 1.0, name: '100%');
