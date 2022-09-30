import 'meta_localization_definition.dart';
import 'meta_stories_definition.dart';
import 'meta_theme_definition.dart';
import 'standard_mapper.dart';

class MonarchDataDefinition {
  final String packageName;

  /// List of user-annotated localizations
  final List<MetaLocalizationDefinition> metaLocalizations;

  /// List of user-annotated themes
  final List<MetaThemeDefinition> metaThemes;

  /// It maps generated meta-stories path to its meta-stories object.
  /// As of 2020-04-15, the key looks like `$packageName|$generatedStoriesFilePath`
  final Map<String, MetaStoriesDefinition> metaStoriesMap;

  Iterable<String> get allLocaleLanguageTags =>
      metaLocalizations.expand((m) => m.localeLanguageTags);

  MonarchDataDefinition(
      {required this.packageName,
      required this.metaLocalizations,
      required this.metaThemes,
      required this.metaStoriesMap});
}

class MonarchDataDefinitionMapper
    implements StandardMapper<MonarchDataDefinition> {
  @override
  MonarchDataDefinition fromStandardMap(Map<String, dynamic> args) {
    String packageName = args['packageName'];
    List<MetaLocalizationDefinition> metaLocalizations =
        args['metaLocalizations']
            .map<MetaLocalizationDefinition>(
                (e) => MetaLocalizationDefinitionMapper().fromStandardMap(e))
            .toList();

    List<MetaThemeDefinition> metaThemes = args['metaThemes']
        .map<MetaThemeDefinition>(
            (e) => MetaThemeDefinitionMapper().fromStandardMap(e))
        .toList();

    Map<String, MetaStoriesDefinition> metaStoriesMap = args['metaStoriesMap']
        .map<String, MetaStoriesDefinition>((key, value) =>
            MapEntry<String, MetaStoriesDefinition>(
                key, MetaStoriesDefinitionMapper().fromStandardMap(value)));

    return MonarchDataDefinition(
        packageName: packageName,
        metaLocalizations: metaLocalizations,
        metaThemes: metaThemes,
        metaStoriesMap: metaStoriesMap);
  }

  @override
  Map<String, dynamic> toStandardMap(MonarchDataDefinition obj) => {
        'packageName': obj.packageName,
        'metaLocalizations': obj.metaLocalizations
            .map((e) => MetaLocalizationDefinitionMapper().toStandardMap(e))
            .toList(),
        'metaThemes': obj.metaThemes
            .map((e) => MetaThemeDefinitionMapper().toStandardMap(e))
            .toList(),
        'metaStoriesMap': obj.metaStoriesMap.map((key, value) =>
            MapEntry(key, MetaStoriesDefinitionMapper().toStandardMap(value)))
      };
}
