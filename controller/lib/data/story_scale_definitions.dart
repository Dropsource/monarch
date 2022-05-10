class StoryScaleDefinition {
  const StoryScaleDefinition({required this.scale, required this.name});

  final double scale;
  final String name;

  static StoryScaleDefinition fromStandardMap(dynamic args) {
    return StoryScaleDefinition(scale: args['scale'], name: args['name']);
  }

  Map<String, dynamic> toStandardMap() {
    return {
      'scale': scale,
      'name': name
    };
  }
}

List<StoryScaleDefinition> getStoryScaleDefinitions(dynamic args) {
  var defsArgs = List.from(args['definitions']);
  return defsArgs.map<StoryScaleDefinition>((e) => StoryScaleDefinition.fromStandardMap(e)).toList();
}

const defaultScaleDefinition = StoryScaleDefinition(scale: 1.0, name: '100%');
