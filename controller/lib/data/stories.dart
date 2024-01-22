import 'package:flutter/foundation.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

final notAscii = RegExp(r'[^ -~]');

class StoryGroup {
  final String _groupName;
  final List<StoryId> stories;
  final String groupKey;

  String get groupName => notAscii.hasMatch(_groupName) ? _groupName.replaceFirst('_stories', '') :  _groupName;

  StoryGroup({
    required String groupName,
    required this.stories,
    required this.groupKey,
  }) : _groupName = groupName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryGroup && _groupName == other._groupName && listEquals(stories, other.stories);

  @override
  int get hashCode => _groupName.hashCode ^ stories.hashCode;

  StoryGroup copyWith({List<StoryId>? stories}) {
    return StoryGroup(
      groupName: _groupName,
      stories: stories ?? this.stories,
      groupKey: groupKey,
    );
  }
}
