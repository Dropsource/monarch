import 'package:flutter_test/flutter_test.dart';
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/manager/search_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

void main() {
  final cut = SearchManager();

  group('Tests for search manager', () {
    test('should not filter anything when search query is empty', () async {
      final input = _testData();
      final output = cut.filterStories(input, '');

      expect(true, listEquals(output.toList(), input));
    });

    test(
        'should not filter anything when search query is present, but input is empty',
        () async {
      final input = <StoryGroup>[];
      final output = cut.filterStories(input, 'hello');

      expect(true, listEquals(output.toList(), input));
    });

    test('should filter by the group name and preserve all stories if match.',
        () async {
      final input = _testData();
      final output = cut.filterStories(input, 'first_group');

      expect(1, output.length);
      expect(3, output.toList()[0].stories.length);
    });

    test('should filter out individual stories from the group by name',
        () async {
      final input = _testData();
      final output = cut.filterStories(input, 'first_story');

      expect(2, output.length);
      expect(1, output.toList()[0].stories.length);
      expect(1, output.toList()[1].stories.length);
    });

    test('should filter out everything if query text has no match', () async {
      final input = _testData();
      final output = cut.filterStories(input, 'monarch is awesome');

      expect(0, output.length);
    });
  });
}

List<StoryGroup> _testData() => [
      StoryGroup(
          groupKey: 'first_group_key',
          groupName: 'first_group',
          stories: [
            StoryId(
              storiesMapKey: 'first_group',
              package: 'test',
              path: 'a/b/first_stories.dart',
              storyName: 'first_story',
            ),
            StoryId(
              storiesMapKey: 'first_group',
              package: 'test',
              path: 'a/b/first_stories.dart',
              storyName: 'second_story',
            ),
            StoryId(
              storiesMapKey: 'first_group',
              package: 'test',
              path: 'a/b/first_stories.dart',
              storyName: 'third_story',
            ),
          ]),
      StoryGroup(
        groupKey: 'second_group_key',
        groupName: 'second_group',
        stories: [
          StoryId(
            storiesMapKey: 'second_group',
            package: 'test',
            path: 'a/b/second_stories.dart',
            storyName: 'first_story_in_second_group',
          ),
          StoryId(
            storiesMapKey: 'second_group',
            package: 'test',
            path: 'a/b/second_stories.dart',
            storyName: 'second_story_in_second_group',
          ),
        ],
      )
    ];
