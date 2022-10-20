import 'meta_localization_definition.dart';
import 'meta_stories_definition.dart';
import 'meta_theme_definition.dart';
import 'standard_mapper.dart';
import 'story_id.dart';

class MonarchDataDefinition {
  final String packageName;

  /// List of user-annotated localizations
  final List<MetaLocalizationDefinition> metaLocalizationDefinitions;

  /// List of user-annotated themes
  final List<MetaThemeDefinition> metaThemeDefinitions;

  /// It maps generated meta-stories path to its meta-stories object.
  /// As of 2020-04-15, the key looks like `$packageName|$generatedStoriesFilePath`
  final Map<String, MetaStoriesDefinition> metaStoriesDefinitionMap;

  Iterable<String> get allLocaleLanguageTags =>
      metaLocalizationDefinitions.expand((m) => m.localeLanguageTags);

  MonarchDataDefinition(
      {required this.packageName,
      required this.metaLocalizationDefinitions,
      required this.metaThemeDefinitions,
      required this.metaStoriesDefinitionMap});

  bool hasStory(StoryId storyId) =>
      metaStoriesDefinitionMap.containsKey(storyId.storiesMapKey) &&
      metaStoriesDefinitionMap[storyId.storiesMapKey]!
          .storiesNames
          .contains(storyId.storyName);
}

class MonarchDataDefinitionMapper
    implements StandardMapper<MonarchDataDefinition> {
  @override
  MonarchDataDefinition fromStandardMap(Map<String, dynamic> args) {
    String packageName = args['packageName'];
    List<MetaLocalizationDefinition> metaLocalizationsDefinitions =
        args['metaLocalizations']
            .map<MetaLocalizationDefinition>((e) =>
                MetaLocalizationDefinitionMapper()
                    .fromStandardMap(Map<String, dynamic>.from(e)))
            .toList();

    List<MetaThemeDefinition> metaThemesDefinitions = args['metaThemes']
        .map<MetaThemeDefinition>((e) => MetaThemeDefinitionMapper()
            .fromStandardMap(Map<String, dynamic>.from(e)))
        .toList();

    var metaStoriesMap = Map<String, dynamic>.from(args['metaStoriesMap']);

    Map<String, MetaStoriesDefinition> metaStoriesDefinitionMap = metaStoriesMap
        .map<String, MetaStoriesDefinition>((key, value) => MapEntry(
            key,
            MetaStoriesDefinitionMapper()
                .fromStandardMap(Map<String, dynamic>.from(value))));

    return MonarchDataDefinition(
        packageName: packageName,
        metaLocalizationDefinitions: metaLocalizationsDefinitions,
        metaThemeDefinitions: metaThemesDefinitions,
        metaStoriesDefinitionMap: metaStoriesDefinitionMap);
  }

  @override
  Map<String, dynamic> toStandardMap(MonarchDataDefinition obj) => {
        'packageName': obj.packageName,
        'metaLocalizations': obj.metaLocalizationDefinitions
            .map((e) => MetaLocalizationDefinitionMapper().toStandardMap(e))
            .toList(),
        'metaThemes': obj.metaThemeDefinitions
            .map((e) => MetaThemeDefinitionMapper().toStandardMap(e))
            .toList(),
        'metaStoriesMap': obj.metaStoriesDefinitionMap
            .map<String, Map<String, dynamic>>((key, value) => MapEntry(
                key, MetaStoriesDefinitionMapper().toStandardMap(value)))
      };
}
