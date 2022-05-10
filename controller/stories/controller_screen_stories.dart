import 'package:flutter/material.dart';
import 'package:monarch_controller/data/monarch_data.dart';
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/manager/controller_state.dart';
import 'package:monarch_controller/screens/controller_screen.dart';

Widget filterableStories() => ControllerScreen(
        manager: ControllerManager(
      initialState: ControllerState.init().copyWith(
          isReady: true,
          storiesMap: {
            'test_project|stories/sample_button_stories.meta_stories.g.dart':
                const MetaStories(package: 'test', path: 'path', storiesNames: [
              'primaryButton',
              'secondaryButton',
              'tertiaryButton'
            ])
          },
          packageName: 'monarch_demo'),
    ));
