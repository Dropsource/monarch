class StoryGroup {
  final String groupName;
  final List<Story> stories;

  StoryGroup({
    required this.groupName,
    required this.stories,
  });
}

class Story {
  final String name;
  final String key;

  Story({
    required this.name,
    required this.key,
  });
}
