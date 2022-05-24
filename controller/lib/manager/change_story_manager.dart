import '../data/stories.dart';

abstract class ChangeStoryManager {
  Story? prevStory(
      {String? activeStoryKey,
      required Set<String> collapsedGroupKeys,
      required List<StoryGroup> storyGroups});

  Story? nextStory(
      {String? activeStoryKey,
      required Set<String> collapsedGroupKeys,
      required List<StoryGroup> storyGroups});
}

class ChangeStoryManagerImpl implements ChangeStoryManager {
  @override
  Story? nextStory(
      {String? activeStoryKey,
      required Set<String> collapsedGroupKeys,
      required List<StoryGroup> storyGroups}) {
    return _changeStory(
        activeStoryKey: activeStoryKey,
        collapsedGroupKeys: collapsedGroupKeys,
        storyGroups: storyGroups,
        lookupStartFunction: (arr) => 0,
        endLookupFunction: (array, index) => index < array.length,
        incrementByValue: 1);
  }

  @override
  Story? prevStory(
      {String? activeStoryKey,
      required Set<String> collapsedGroupKeys,
      required List<StoryGroup> storyGroups}) {
    return _changeStory(
      activeStoryKey: activeStoryKey,
      collapsedGroupKeys: collapsedGroupKeys,
      storyGroups: storyGroups,
      lookupStartFunction: (array) => array.length - 1,
      endLookupFunction: (array, index) => index >= 0,
      incrementByValue: -1,
    );
  }

  Story? _changeStory({
    String? activeStoryKey,
    required Set<String> collapsedGroupKeys,
    required List<StoryGroup> storyGroups,
    required int Function(List array) lookupStartFunction,
    required bool Function(List array, int index) endLookupFunction,
    required int incrementByValue,
  }) {
    if (storyGroups.isEmpty) {
      return null;
    }

    bool hasActiveStory = activeStoryKey != null;

    //select first non-collapsed group
    bool returnNext = false;

    for (int a = lookupStartFunction(storyGroups);
        endLookupFunction(storyGroups, a);
        a += incrementByValue) {
      final group = storyGroups[a];
      if (group.stories.isEmpty ||
          collapsedGroupKeys.contains(group.groupKey)) {
        //this group is empty or collapsed, lets move on
        continue;
      }

      for (int b = lookupStartFunction(group.stories);
          endLookupFunction(group.stories, b);
          b += incrementByValue) {
        final story = group.stories[b];

        if (returnNext) {
          return story;
        }

        if (!hasActiveStory) {
          return story;
        } else {
          if (!returnNext) {
            returnNext = story.key == activeStoryKey;
          }
        }
      }
    }
    //nothing found that matches criteria
    return null;
  }
}
