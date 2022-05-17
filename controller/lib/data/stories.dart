import 'package:flutter/foundation.dart';

class StoryGroup {
  final String groupName;
  final List<Story> stories;

  StoryGroup({
    required this.groupName,
    required this.stories,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryGroup &&
          groupName == other.groupName &&
          listEquals(stories, other.stories);

  @override
  int get hashCode => groupName.hashCode ^ stories.hashCode;

  StoryGroup copyWith({List<Story>? stories}) {
    return StoryGroup(groupName: groupName, stories: stories ?? this.stories);
  }
}

class Story {
  final String name;
  final String key;

  Story({
    required this.name,
    required this.key,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Story &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          key == other.key;

  @override
  int get hashCode => name.hashCode ^ key.hashCode;
}
