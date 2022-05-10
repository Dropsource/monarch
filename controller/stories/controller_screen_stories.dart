import 'package:flutter/material.dart';
import 'package:monarch_controller/data/monarch_data.dart';
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
            ])
          ],
          packageName: 'monarch_demo'),
    ));
