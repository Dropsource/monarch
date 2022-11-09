import '../monarch_definitions.dart';

class StoryId {
  final String storiesMapKey;
  final String package;
  final String path;
  final String storyName;

  StoryId(
      {required this.storiesMapKey,
      required this.package,
      required this.path,
      required this.storyName});

  String get key => '$storiesMapKey|$storyName';

  @override
  String toString() => '$package|$path|$storyName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryId &&
          runtimeType == other.runtimeType &&
          storiesMapKey == other.storiesMapKey &&
          package == other.package &&
          path == other.path &&
          storyName == other.storyName;

  @override
  int get hashCode =>
      storiesMapKey.hashCode ^
      package.hashCode ^
      path.hashCode ^
      storyName.hashCode;
}

class StoryIdMapper implements StandardMapper<StoryId> {
  @override
  StoryId fromStandardMap(Map<String, dynamic> args) => StoryId(
      storiesMapKey: args['storiesMapKey'],
      package: args['package'],
      path: args['path'],
      storyName: args['storyName']);

  @override
  Map<String, dynamic> toStandardMap(StoryId obj) => {
        'storiesMapKey': obj.storiesMapKey,
        'package': obj.package,
        'path': obj.path,
        'storyName': obj.storyName,
      };
}
