import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';
import 'package:monarch_window_controller/window_controller/window_controller_manager.dart';
import 'package:monarch_window_controller/window_controller/window_controller_screen.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';

Widget filterableStories() => WindowControllerScreen(
        manager: WindowControllerManager(
      initialState: WindowControllerState.init().copyWith(
        active: true,
          monarchData: MonarchData(
              packageName: 'test',
              metaLocalizations: [],
              metaThemes: [],
              metaStoriesMap: {
            'test_project|stories/sample_button_stories.meta_stories.g.dart':
                const MetaStories(package: 'test', path: 'path', storiesNames: [
              'primaryButton',
              'secondaryButton',
              'tertiaryButton'
            ])
          })),
    ));
