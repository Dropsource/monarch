import 'package:flutter/material.dart';
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/manager/controller_state.dart';
import 'package:monarch_controller/screens/controller_screen.dart';

Widget filterableStories() => ControllerScreen(
        manager: ControllerManager(
      initialState: ControllerState.init().copyWith(
          isReady: true,
          storyGroups: [
            StoryGroup(groupName: 'sample_button_stories', stories: [
              Story(name: 'primary', key: 'key-primary'),
              Story(name: 'secondary', key: 'key-secondary'),
              Story(name: 'disabled', key: 'key-disabled'),
            ]),
            StoryGroup(groupName: 'other_sample_button_stories', stories: [
              Story(name: 'tertiary', key: 'key-tertiary'),
              Story(name: 'gone', key: 'key-gone'),
            ]),
            StoryGroup(groupName: 'long_list_of_stories', stories: [
              Story(name: 'story_1', key: 'key-story-1'),
              Story(name: 'story_2', key: 'key-story-2'),
              Story(name: 'story_3', key: 'key-story-3'),
              Story(name: 'story_4', key: 'key-story-4'),
              Story(name: 'story_5', key: 'key-story-5'),
              Story(name: 'story_6', key: 'key-story-6'),
              Story(name: 'story_7', key: 'key-story-7'),
              Story(name: 'story_8', key: 'key-story-8'),
              Story(name: 'story_9', key: 'key-story-9'),
              Story(name: 'story_10', key: 'key-story-10'),
              Story(name: 'story_11', key: 'key-story-11'),
              Story(name: 'story_12', key: 'key-story-12'),
              Story(name: 'story_13', key: 'key-story-13'),
              Story(name: 'story_14', key: 'key-story-14'),
            ])
          ],
          packageName: 'monarch_demo'),
    ));
