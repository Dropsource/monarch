import 'package:flutter_test/flutter_test.dart';
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/manager/search_manager.dart';
import 'package:flutter/foundation.dart';

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
      StoryGroup(groupName: 'first_group', stories: [
        Story(name: 'first_story', key: 'first_story_key'),
        Story(name: 'second_story', key: 'second_story_key'),
        Story(name: 'third_story', key: 'third_story_key'),
      ]),
      StoryGroup(
        groupName: 'second_group',
        stories: [
          Story(
              name: 'first_story_in_second_group',
              key: 'first_story_in_second_group_key'),
          Story(
              name: 'second_story_in_second_group',
              key: 'second_story_in_second_group_key'),
        ],
      )
    ];
