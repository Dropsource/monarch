class MetaStories {
  /// Name of the user project or package
  final String package;

  /// Path to the `_stories.dart` file the user authored
  final String path;

  /// List of story names in the stories file
  final List<String> storiesNames;

  const MetaStories(
      {required this.package, required this.path, required this.storiesNames});

  static MetaStories fromStandardMap(dynamic args) {
    return MetaStories(
        package: args['package'],
        path: args['path'],
        storiesNames: List.from(
          args['storiesNames'].cast<String>(),
        ));
  }

  MetaStories copyWith({List<String>? storiesNames}) {
    return MetaStories(
        package: package,
        path: path,
        storiesNames: storiesNames ?? this.storiesNames);
  }
}

class MetaTheme {
  final String id;
  final String name;
  final bool isDefault;

  const MetaTheme(
      {required this.id, required this.name, required this.isDefault});

  static MetaTheme fromStandardMap(dynamic args) {
    return MetaTheme(
        id: args['id'], name: args['name'], isDefault: args['isDefault']);
  }
}

class MetaLocalization {
  final List<String> locales;
  final String delegateClassName;

  MetaLocalization({required this.locales, required this.delegateClassName});

  static MetaLocalization fromStandardMap(dynamic args) {
    return MetaLocalization(
        locales: List.from(args['locales'].cast<String>()),
        delegateClassName: args['delegateClassName']);
  }
}

class MonarchData {
  final String packageName;

  /// List of user-annotated localizations
  final List<MetaLocalization> metaLocalizations;

  /// List of user-annotated themes
  final List<MetaTheme> metaThemes;

  /// It maps generated meta-stories path to its meta-stories object.
  /// As of 2020-04-15, the key looks like `$packageName|$generatedStoriesFilePath`
  final Map<String, MetaStories> metaStoriesMap;

  Iterable<String> get allLocales => metaLocalizations.expand((m) => m.locales);

  MonarchData(
      {required this.packageName,
      required this.metaLocalizations,
      required this.metaThemes,
      required this.metaStoriesMap});

  static MonarchData fromStandardMap(Map<String, dynamic> args) {
    String packageName = args['packageName'];
    List<MetaLocalization> metaLocalizations = args['metaLocalizations']
        .map<MetaLocalization>((e) => MetaLocalization.fromStandardMap(e))
        .toList();
    List<MetaTheme> metaThemes = args['metaThemes']
        .map<MetaTheme>((e) => MetaTheme.fromStandardMap(e))
        .toList();

    Map<String, MetaStories> metaStoriesMap = args['metaStoriesMap']
        .map<String, MetaStories>((key, value) => MapEntry<String, MetaStories>(
            key, MetaStories.fromStandardMap(value)));

    return MonarchData(
        packageName: packageName,
        metaLocalizations: metaLocalizations,
        metaThemes: metaThemes,
        metaStoriesMap: metaStoriesMap);
  }
}

List<MetaTheme> getStandardThemes(dynamic args) {
  final themes = args['standardThemes'];
  return themes
      .map<MetaTheme>((element) => MetaTheme.fromStandardMap(element))
      .toList();
}
