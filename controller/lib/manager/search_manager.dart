import '../data/stories.dart';

class SearchManager {
  Iterable<StoryGroup> filterStories(
      List<StoryGroup> stories, String searchPhrase) {
    final output = [];
    final query = searchPhrase.toLowerCase();

    for (var a = 0; a < stories.length; a++) {
      final group = stories[a];

      if (group.groupName.toLowerCase().contains(query)) {
        //got a group name match, preserving all stories from the group
        output.add(group);
        continue;
      } else {
        //no match, trying to filter out individual stories
        final storyOutput = <Story>[];

        for (var b = 0; b < group.stories.length; b++) {
          final story = group.stories[b];
          if (story.name.toLowerCase().contains(query)) {
            storyOutput.add(story);
          }
        }

        //include group only if at least 1 story were found
        if (storyOutput.isNotEmpty) {
          output.add(group.copyWith(stories: storyOutput));
        }
      }
    }

    return Iterable.castFrom(output);
  }
}
