import 'standard_mapper.dart';

const defaultScaleDefinition = StoryScaleDefinition(scale: 1.0, name: '100%');

class StoryScaleDefinition {
  const StoryScaleDefinition({required this.scale, required this.name});
  final double scale;
  final String name;
}

class StoryScaleDefinitionMapper implements StandardMapper {
  @override
  fromStandardMap(Map<String, dynamic> args) =>
      StoryScaleDefinition(scale: args['scale'], name: args['name']);

  @override
  Map<String, dynamic> toStandardMap(obj) =>
      {'scale': obj.scale, 'name': obj.name};
}

class StoryScaleDefinitionListMapper
    implements StandardMapperList<StoryScaleDefinition> {
  @override
  List<StoryScaleDefinition> fromStandardMap(Map<String, dynamic> args) {
    var defsArgs = List.from(args['definitions']);
    return defsArgs
        .map<StoryScaleDefinition>(
            (e) => StoryScaleDefinitionMapper().fromStandardMap(e))
        .toList();
  }

  @override
  Map<String, dynamic> toStandardMap(List<StoryScaleDefinition> list) => {
        'definitions': list
            .map((obj) => StoryScaleDefinitionMapper().toStandardMap(obj))
            .toList(),
      };
}
