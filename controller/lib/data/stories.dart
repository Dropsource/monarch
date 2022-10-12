import 'package:flutter/foundation.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

class StoryGroup {
  final String groupName;
  final List<StoryId> stories;
  final String groupKey;

  StoryGroup({
    required this.groupName,
    required this.stories,
    required this.groupKey,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryGroup &&
          groupName == other.groupName &&
          listEquals(stories, other.stories);

  @override
  int get hashCode => groupName.hashCode ^ stories.hashCode;

  StoryGroup copyWith({List<StoryId>? stories}) {
    return StoryGroup(
      groupName: groupName,
      stories: stories ?? this.stories,
      groupKey: groupKey,
    );
  }
}
