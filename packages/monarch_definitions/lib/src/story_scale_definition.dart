import 'standard_mapper.dart';

const defaultScaleDefinition = StoryScaleDefinition(scale: 1.0, name: '100%');

class StoryScaleDefinition {
  const StoryScaleDefinition({required this.scale, required this.name});
  final double scale;
  final String name;
}

class StoryScaleDefinitionMapper
    implements StandardMapper<StoryScaleDefinition> {
  @override
  StoryScaleDefinition fromStandardMap(Map<String, dynamic> args) =>
      StoryScaleDefinition(scale: args['scale'], name: args['name']);

  @override
  Map<String, dynamic> toStandardMap(StoryScaleDefinition obj) =>
      {'scale': obj.scale, 'name': obj.name};
}
