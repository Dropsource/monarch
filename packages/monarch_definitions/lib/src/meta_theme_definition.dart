import 'standard_mapper.dart';

const materialLightThemeDefinition = MetaThemeDefinition(
    id: '__material-light-theme__',
    name: 'Material 2 Light Theme',
    isDefault: true);
const materialDarkThemeDefinition = MetaThemeDefinition(
    id: '__material-dark-theme__',
    name: 'Material 2 Dark Theme',
    isDefault: false);
const material3LightThemeDefinition = MetaThemeDefinition(
    id: '__material-3-light-theme__',
    name: 'Material 3 Light Theme',
    isDefault: false);
const material3DarkThemeDefinition = MetaThemeDefinition(
    id: '__material-3-dark-theme__',
    name: 'Material 3 Dark Theme',
    isDefault: false);

const defaultThemeDefinition = materialLightThemeDefinition;

const standardMetaThemeDefinitions = [
  materialLightThemeDefinition,
  materialDarkThemeDefinition,
  // material3LightThemeDefinition,
  // material3DarkThemeDefinition,
];

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
