import 'standard_mapper.dart';

class MetaStoriesDefinition {
  /// Name of the user project or package
  final String package;

  /// Path to the `_stories.dart` file the user authored
  final String path;

  /// List of story names in the stories file
  final List<String> storiesNames;

  MetaStoriesDefinition(
      {required this.package, required this.path, required this.storiesNames});

  MetaStoriesDefinition copyWith({List<String>? storiesNames}) {
    return MetaStoriesDefinition(
        package: package,
        path: path,
        storiesNames: storiesNames ?? this.storiesNames);
  }
}

class MetaStoriesDefinitionMapper
    implements StandardMapper<MetaStoriesDefinition> {
  @override
  MetaStoriesDefinition fromStandardMap(Map<String, dynamic> args) =>
      MetaStoriesDefinition(
          package: args['package'],
          path: args['path'],
          storiesNames: List.from(
            args['storiesNames'].cast<String>(),
          ));

  @override
  Map<String, dynamic> toStandardMap(MetaStoriesDefinition obj) => {
        'package': obj.package,
        'path': obj.path,
        'storiesNames': obj.storiesNames
      };
}
