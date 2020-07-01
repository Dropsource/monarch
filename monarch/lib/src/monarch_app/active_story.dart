import 'dart:async';

import 'package:monarch_utils/log.dart';

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
}

class ActiveStory with Log {
  StoryId _activeStoryId;

  StoryId get activeStoryId => _activeStoryId;

  final _activeStoryChangeStreamController =
      StreamController<void>.broadcast();
  Stream<void> get activeStoryChangeStream =>
      _activeStoryChangeStreamController.stream;

  void setActiveStory(String key) {
    _activeStoryId = StoryId.fromNodeKey(key);
    _activeStoryChangeStreamController.add(null);
    log.info('active story id set: $key');
  }

  void resetActiveStory() {
    _activeStoryId = null;
    _activeStoryChangeStreamController.add(null);
    log.info('active story id reset');
  }

  void close() {
    _activeStoryChangeStreamController.close();
  }
}

final activeStory = ActiveStory();
