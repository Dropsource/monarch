import 'active_value.dart';

class StoryId {
  final String package;

  /// The generated stories path. As of 2020-05-08, this path is
  /// relative to the stories directory.
  /// It looks like 'stories/foo_stories.g.dart'.
  final String path;

  final String name;

  const StoryId(this.package, this.path, this.name);

  factory StoryId.fromNodeKey(String key) {
    ArgumentError.checkNotNull(key, 'key');
    final segments = key.split('|');
    if (segments.length != 3) {
      throw ArgumentError('story id key must have 3 piped segments');
    }

    return StoryId(segments[0], segments[1], segments[2]);
  }

  String get pathKey => '$package|$path';
  String get storyKey => '$package|$path|$name';

  @override
  String toString() => storyKey;
}

class ActiveStory extends ActiveValue<StoryId?> {
  StoryId? _activeStoryId;

  @override
  StoryId? get value => _activeStoryId;

  @override
  void setValue(StoryId? newValue) {
    _activeStoryId = newValue;
  }

  @override
  String get valueSetMessage => value == null
      ? 'active story id reset'
      : 'active story id set: ${value!}';
}

final activeStory = ActiveStory();
