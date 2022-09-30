import 'standard_mapper.dart';

class MetaThemeDefinition {
  final String id;
  final String name;
  final bool isDefault;

  const MetaThemeDefinition(
      {required this.id, required this.name, required this.isDefault});
}

class MetaThemeDefinitionMapper implements StandardMapper<MetaThemeDefinition> {
  @override
  MetaThemeDefinition fromStandardMap(Map<String, dynamic> args) =>
      MetaThemeDefinition(
          id: args['id'], name: args['name'], isDefault: args['isDefault']);

  @override
  Map<String, dynamic> toStandardMap(MetaThemeDefinition obj) =>
      {'id': obj.id, 'name': obj.name, 'isDefault': obj.isDefault};
}
