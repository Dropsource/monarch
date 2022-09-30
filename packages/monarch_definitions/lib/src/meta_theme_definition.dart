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

class StandardThemesMapper implements StandardMapperList<MetaThemeDefinition> {
  @override
  List<MetaThemeDefinition> fromStandardMap(Map<String, dynamic> args) {
    final themes = args['standardThemes'];
    return themes
        .map<MetaThemeDefinition>(
            (element) => MetaThemeDefinitionMapper().fromStandardMap(element))
        .toList();
  }

  @override
  Map<String, dynamic> toStandardMap(List<MetaThemeDefinition> list) => {
        'standardThemes': list
            .map((d) => MetaThemeDefinitionMapper().toStandardMap(d))
            .toList(),
      };
}
