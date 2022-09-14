import 'package:flutter/material.dart';
import 'package:monarch_controller/data/device_definitions.dart';
import 'package:monarch_controller/data/logical_resolution.dart';
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/manager/controller_state.dart';
import 'package:monarch_controller/screens/controller_screen.dart';
import 'package:monarch_controller/data/definitions.dart' as defs;
import 'package:monarch/src/preview/device_definitions.dart' as preview;

import 'story_utils.dart';

//ignore_for_file: non_constant_identifier_names

Widget state_not_ready() => ControllerScreen(
        manager: ControllerManager(
      channelMethodsSender: mockChannelMethodsSender,
      initialState: ControllerState.init()
          .copyWith(isPreviewReady: false, packageName: 'monarch_demo'),
    ));

Widget empty_story_list() => ControllerScreen(
      manager: ControllerManager(
          channelMethodsSender: mockChannelMethodsSender,
          initialState: ControllerState.init()
              .copyWith(isPreviewReady: true, storyGroups: [])),
    );

Widget sample_story_list() => ControllerScreen(
        manager: ControllerManager(
      channelMethodsSender: mockChannelMethodsSender,
      initialState: ControllerState.init().copyWith(
          isPreviewReady: true,
          storyGroups: _longStoryList(),
          packageName: 'monarch_demo'),
    ));

Widget devices_themes_and_locales_list() => ControllerScreen(
        manager: ControllerManager(
      channelMethodsSender: mockChannelMethodsSender,
      initialState: ControllerState.init().copyWith(
          isPreviewReady: true,
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
      channelMethodsSender: mockChannelMethodsSender,
      initialState: ControllerState.init().copyWith(
          isPreviewReady: true,
          storyGroups: _longStoryList(),
          devices: preview.deviceDefinitions
              .map((e) => DeviceDefinition(
                  id: e.id,
                  name: e.name,
                  logicalResolution: LogicalResolution(
                      height: e.logicalResolution.height,
                      width: e.logicalResolution.width),
                  devicePixelRatio: e.devicePixelRatio,
                  targetPlatform: e.targetPlatform))
              .toList(),
          packageName: 'monarch_demo'),
    ));

Widget all_dev_tools_enabled() => ControllerScreen(
        manager: ControllerManager(
      channelMethodsSender: mockChannelMethodsSender,
      initialState: ControllerState.init().copyWith(
          isPreviewReady: true,
          storyGroups: _longStoryList(),
          visualDebugFlags: defs.devToolsOptions
              .map((e) => e.copyWith(enabled: true))
              .toList(),
          packageName: 'monarch_demo'),
    ));

List<StoryGroup> _longStoryList() => [
      StoryGroup(
          groupName: 'sample_button_stories',
          stories: [
            Story(name: 'primary', key: 'key-primary'),
            Story(name: 'secondary', key: 'key-secondary'),
            Story(name: 'disabled', key: 'key-disabled'),
          ],
          groupKey: 'simple_list_key'),
      StoryGroup(
        groupName: 'other_sample_button_stories',
        stories: [
          Story(name: 'tertiary', key: 'key-tertiary'),
          Story(name: 'gone', key: 'key-gone'),
        ],
        groupKey: 'other_list_key',
      ),
      StoryGroup(
        groupName: 'long_list_of_stories',
        stories: [
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
        ],
        groupKey: 'long_list_key',
      )
    ];
