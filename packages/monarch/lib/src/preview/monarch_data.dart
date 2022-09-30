import 'package:flutter/material.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

typedef StoryFunction = Widget Function();

class MetaStories extends MetaStoriesDefinition {
  /// Maps story name to its function
  final Map<String, StoryFunction> storiesMap;

  MetaStories(
      String package, String path, List<String> storiesNames, this.storiesMap)
      : super(package: package, path: path, storiesNames: storiesNames);
}

class MetaTheme extends MetaThemeDefinition {
  final ThemeData? theme;

  MetaTheme(String id, String name, this.theme, bool isDefault)
      : super(id: id, name: name, isDefault: isDefault);

  MetaTheme.user(String name, dynamic dynamicTheme, bool isDefault)
      : theme = dynamicTheme is ThemeData ? dynamicTheme : null,
        super(id: name, name: name, isDefault: isDefault);
}

class MetaLocalization extends MetaLocalizationDefinition {
  final List<Locale> locales;
  final LocalizationsDelegate? delegate;

  MetaLocalization.user(
      this.locales, dynamic dynamicLocalization, String delegateClassName)
      : delegate = dynamicLocalization is LocalizationsDelegate
            ? dynamicLocalization
            : null,
        super(
            localeLanguageTags: locales.map((e) => e.toLanguageTag()).toList(),
            delegateClassName: delegateClassName);
}

class MonarchData extends MonarchDataDefinition {
  MonarchData(String packageName, List<MetaLocalization> metaLocalizations,
      List<MetaTheme> metaThemes, Map<String, MetaStories> metaStoriesMap)
      : super(
            packageName: packageName,
            metaLocalizationDefinitions: metaLocalizations,
            metaThemeDefinitions: metaThemes,
            metaStoriesDefinitionMap: metaStoriesMap);

  List<MetaLocalization> get metaLocalizations =>
      metaLocalizationDefinitions.map((e) => e as MetaLocalization).toList();

  List<MetaTheme> get metaThemes =>
      metaThemeDefinitions.map((e) => e as MetaTheme).toList();

  Map<String, MetaStories> get metaStoriesMap => metaStoriesDefinitionMap
      .map((key, value) => MapEntry(key, value as MetaStories));

  Iterable<Locale> get allLocales =>
      metaLocalizations.expand((element) => element.locales);
}
