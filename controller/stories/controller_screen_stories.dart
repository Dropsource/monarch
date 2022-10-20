import 'package:flutter/material.dart';
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/manager/controller_state.dart';
import 'package:monarch_controller/screens/controller_screen.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

import 'story_utils.dart';

//ignore_for_file: non_constant_identifier_names

Widget state_not_ready() => ControllerScreen(
        manager: ControllerManager(
      initialState: ControllerState.init()
          .copyWith(isReady: false, packageName: 'monarch_demo'),
    ));

Widget empty_story_list() => ControllerScreen(
      manager: ControllerManager(
          initialState:
              ControllerState.init().copyWith(isReady: true, storyGroups: [])),
    );

Widget sample_story_list() => ControllerScreen(
        manager: ControllerManager(
      initialState: ControllerState.init().copyWith(
          isReady: true,
          storyGroups: _longStoryList(),
          packageName: 'monarch_demo'),
    ));

Widget devices_themes_and_locales_list() => ControllerScreen(
        manager: ControllerManager(
      initialState: ControllerState.init().copyWith(
          isReady: true,
          storyGroups: _longStoryList(),
          devices: deviceDefinitions,
          locales: [
            'en-US',
            'es-US',
            'en-UK',
          ],
          currentLocale: 'en-US',
          standardThemes: standardMetaThemes,
          packageName: 'monarch_demo'),
    ));

Widget devices_long_list() => ControllerScreen(
        manager: ControllerManager(
      initialState: ControllerState.init().copyWith(
          isReady: true,
          storyGroups: _longStoryList(),
          devices: [
            ...deviceDefinitions,
            ...deviceDefinitions,
            ...deviceDefinitions
          ],
          packageName: 'monarch_demo'),
    ));

Widget all_dev_tools_enabled() => ControllerScreen(
        manager: ControllerManager(
      initialState: ControllerState.init().copyWith(
          isReady: true,
          storyGroups: _longStoryList(),
          visualDebugFlags: defaultVisualDebugFlags,
          packageName: 'monarch_demo'),
    ));

List<StoryGroup> _longStoryList() => [
      StoryGroup(
          groupName: 'sample_button_stories',
          stories: [
            StoryId(
                storyName: 'primary',
                storiesMapKey: 'key-primary',
                package: 'foo',
                path: 'foo/sample_button_stories.dart'),
            StoryId(
                storyName: 'secondary',
                storiesMapKey: 'key-secondary',
                package: 'foo',
                path: 'foo/sample_button_stories.dart'),
            StoryId(
                storyName: 'disabled',
                storiesMapKey: 'key-disabled',
                package: 'foo',
                path: 'foo/sample_button_stories.dart'),
          ],
          groupKey: 'simple_list_key'),
      StoryGroup(
        groupName: 'other_sample_button_stories',
        stories: [
          StoryId(
              storyName: 'tertiary',
              storiesMapKey: 'key-tertiary',
              package: 'foo',
              path: 'foo/other_sample_button_stories.dart'),
          StoryId(
              storyName: 'gone',
              storiesMapKey: 'key-gone',
              package: 'foo',
              path: 'foo/other_sample_button_stories.dart'),
        ],
        groupKey: 'other_list_key',
      ),
      StoryGroup(
        groupName: 'long_list_of_stories',
        stories: [
          StoryId(
              storyName: 'story_1',
              storiesMapKey: 'key-story-1',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_2',
              storiesMapKey: 'key-story-2',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_3',
              storiesMapKey: 'key-story-3',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_4',
              storiesMapKey: 'key-story-4',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_5',
              storiesMapKey: 'key-story-5',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_6',
              storiesMapKey: 'key-story-6',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_7',
              storiesMapKey: 'key-story-7',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_8',
              storiesMapKey: 'key-story-8',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_9',
              storiesMapKey: 'key-story-9',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_10',
              storiesMapKey: 'key-story-10',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_11',
              storiesMapKey: 'key-story-11',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_12',
              storiesMapKey: 'key-story-12',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_13',
              storiesMapKey: 'key-story-13',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
          StoryId(
              storyName: 'story_14',
              storiesMapKey: 'key-story-14',
              package: 'foo',
              path: 'foo/long_list_of_stories.dart'),
        ],
        groupKey: 'long_list_key',
      )
    ];
