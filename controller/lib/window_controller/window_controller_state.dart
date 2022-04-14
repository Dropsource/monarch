import 'dart:ui';

import 'package:monarch_window_controller/window_controller/data/dev_tools_option.dart';
import 'package:monarch_window_controller/window_controller/data/device_definitions.dart';
import 'package:monarch_window_controller/window_controller/data/dock_definition.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';
import 'package:monarch_window_controller/window_controller/data/definitions.dart'
    as defs;
import 'package:monarch_window_controller/window_controller/data/story_scale_definitions.dart';

import 'data/definitions.dart';

class WindowControllerState {
  final bool active;
  final MonarchData monarchData;
  final String? activeStoryName;

  final DeviceDefinition currentDevice;
  final List<DeviceDefinition> devices;

  final Locale currentLocale;
  final MetaTheme currentTheme;

  final StoryScaleDefinition currentScale;

  final List<StoryScaleDefinition> scaleList;

  final DockDefinition currentDock;
  final List<DockDefinition> dockList;

  final List<DevToolsOption> devToolOptions;
  final Set<DevToolFeature> enabledDevToolsFeatures;

  final double textScaleFactor;

  WindowControllerState({
    required this.active,
    required this.monarchData,
    this.activeStoryName,
    required this.devices,
    required this.currentDevice,
    required this.currentLocale,
    required this.currentTheme,
    required this.currentDock,
    required this.currentScale,
    required this.dockList,
    required this.scaleList,
    required this.devToolOptions,
    required this.enabledDevToolsFeatures,
    required this.textScaleFactor,
  });

  factory WindowControllerState.test() =>
      WindowControllerState(
        devices: deviceDefinitions,
        currentDevice: defaultDeviceDefinition,
        active: true,
        textScaleFactor: 1.0,
        currentLocale: defs.defaultLocale,
        currentTheme: MetaTheme(
          'theme_id',
          'Default',
          null,
          true,
        ),
        monarchData: MonarchData(
          'test_package_name',
          [
            MetaLocalization([
              const Locale('en', 'US'),
              const Locale('es', 'ES'),
            ], null, 'locale_delegate_class_name'),
          ],
          [
            MetaTheme('theme_id', 'Default', null, true),
            MetaTheme('other_theme_id', 'Material Light', null, false),
          ],
          {
            'test': const MetaStories(
              'package',
              'path',
              [
                'test_story_1',
                'test_story_2',
                'test_story_3',
              ],
              {
                //story name -> widget function
              },
            ),
            'tester': const MetaStories(
              'package',
              'path',
              [
                'tester_story_1',
                'tester_story_2',
                'tester_story_3',
              ],
              {
                //story name -> widget function
              },
            ),
            'long_story': const MetaStories(
              'package',
              'path',
              [
                'long_story_1',
                'long_story_2',
                'long_story_3',
                'long_story_4',
                'long_story_5',
                'long_story_6',
                'long_story_7',
                'long_story_8',
                'long_story_9',
                'long_story_10',
                'long_story_11',
                'long_story_12',
              ],
              {
                //story name -> widget function
              },
            ),
          },
        ),
        activeStoryName: null,
        currentDock: defs.defaultDock,
        dockList: defs.dockList,
        currentScale: defaultScaleDefinition,
        scaleList: storyScaleDefinitions,
        enabledDevToolsFeatures: {},
        devToolOptions: devToolsOptions,
      );

  WindowControllerState copyWith({
    String? activeStoryName,
    MonarchData? monarchData,
    bool? active,
    DeviceDefinition? currentDevice,
    Locale? currentLocale,
    MetaTheme? currentTheme,
    StoryScaleDefinition? currentScale,
    DockDefinition? currentDock,
    Set<DevToolFeature>? enabledDevToolsFeatures,
    double? textScaleFactor,
  }) =>
      WindowControllerState(
        activeStoryName: activeStoryName ?? this.activeStoryName,
        monarchData: monarchData ?? this.monarchData,
        active: active ?? this.active,
        currentDevice: currentDevice ?? this.currentDevice,
        devices: devices,
        currentLocale: currentLocale ?? this.currentLocale,
        currentTheme: currentTheme ?? this.currentTheme,
        scaleList: scaleList,
        currentScale: currentScale ?? this.currentScale,
        dockList: dockList,
        currentDock: currentDock ?? this.currentDock,
        devToolOptions: devToolOptions,
        enabledDevToolsFeatures:
            enabledDevToolsFeatures ?? this.enabledDevToolsFeatures,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      );
}
