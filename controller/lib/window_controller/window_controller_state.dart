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

  WindowControllerState({required this.active});
}

class ConnectedWindowControllerState extends WindowControllerState {
  final MonarchData? monarchData;
  final String? activeStoryName;

  final DeviceDefinition currentDevice;
  final List<DeviceDefinition> devices;

  final String currentLocale;
  final List<String> locales;

  final MetaTheme currentTheme;
  final List<MetaTheme> themes;

  final StoryScaleDefinition currentScale;

  final List<StoryScaleDefinition> scaleList;

  final DockDefinition currentDock;
  final List<DockDefinition> dockList;

  final double textScaleFactor;
  // final List<DevToolsOption> devToolOptions;
  // final Set<DevToolFeature> enabledDevToolsFeatures;

  ConnectedWindowControllerState({
    required bool active,
    this.monarchData,
    this.activeStoryName,
    required this.devices,
    required this.currentDevice,
    required this.locales,
    required this.currentLocale,
    required this.themes,
    required this.currentTheme,
    required this.currentDock,
    required this.currentScale,
    required this.dockList,
    required this.scaleList,
    required this.textScaleFactor,
    // required this.devToolOptions,
    // required this.enabledDevToolsFeatures,
  }) : super(active: active);

  factory ConnectedWindowControllerState.init() =>
      ConnectedWindowControllerState(
          active: false,
          devices: [defaultDeviceDefinition],
          currentDevice: defaultDeviceDefinition,
          locales: [defs.defaultLocale],
          currentLocale: defs.defaultLocale,
          themes: [defs.defaultTheme],
          currentTheme: defs.defaultTheme,
          currentDock: defs.defaultDock,
          currentScale: defaultScaleDefinition,
          dockList: defs.dockList,
          scaleList: [defaultScaleDefinition],
          textScaleFactor: 1.0);

  // factory ConnectedWindowControllerState.test() =>
  //     ConnectedWindowControllerState(
  //       devices: deviceDefinitions,
  //       currentDevice: defaultDeviceDefinition,
  //       active: true,
  //       currentLocale: defs.defaultLocale,
  //       currentTheme: MetaTheme(
  //         'theme_id',
  //         'Default',
  //         null,
  //         true,
  //       ),
  //       monarchData: MonarchData(
  //         'test_package_name',
  //         [
  //           MetaLocalization([
  //             const Locale('en', 'US'),
  //             const Locale('es', 'ES'),
  //           ], null, 'locale_delegate_class_name'),
  //         ],
  //         [
  //           MetaTheme('theme_id', 'Default', null, true),
  //           MetaTheme('other_theme_id', 'Material Light', null, false),
  //         ],
  //         {
  //           'test': const MetaStories(
  //             'package',
  //             'path',
  //             [
  //               'test_story_1',
  //               'test_story_2',
  //               'test_story_3',
  //             ],
  //             {
  //               //story name -> widget function
  //             },
  //           ),
  //           'tester': const MetaStories(
  //             'package',
  //             'path',
  //             [
  //               'tester_story_1',
  //               'tester_story_2',
  //               'tester_story_3',
  //             ],
  //             {
  //               //story name -> widget function
  //             },
  //           ),
  //           'long_story': const MetaStories(
  //             'package',
  //             'path',
  //             [
  //               'long_story_1',
  //               'long_story_2',
  //               'long_story_3',
  //               'long_story_4',
  //               'long_story_5',
  //               'long_story_6',
  //               'long_story_7',
  //               'long_story_8',
  //               'long_story_9',
  //               'long_story_10',
  //               'long_story_11',
  //               'long_story_12',
  //             ],
  //             {
  //               //story name -> widget function
  //             },
  //           ),
  //         },
  //       ),
  //       activeStoryName: null,
  //       currentDock: defs.defaultDock,
  //       dockList: defs.dockList,
  //       currentScale: defaultScaleDefinition,
  //       scaleList: storyScaleDefinitions,
  //       enabledDevToolsFeatures: {},
  //       devToolOptions: devToolsOptions,
  //     );

  ConnectedWindowControllerState copyWith({
    String? activeStoryName,
    MonarchData? monarchData,
    bool? active,
    List<DeviceDefinition>? devices,
    DeviceDefinition? currentDevice,
    String? currentLocale,
    MetaTheme? currentTheme,
    StoryScaleDefinition? currentScale,
    DockDefinition? currentDock,
    double? textScaleFactor,
    // Set<DevToolFeature>? enabledDevToolsFeatures,
  }) =>
      ConnectedWindowControllerState(
        activeStoryName: activeStoryName ?? this.activeStoryName,
        monarchData: monarchData ?? this.monarchData,
        active: active ?? this.active,
        devices: devices ?? this.devices,
        currentDevice: currentDevice ?? this.currentDevice,
        locales: locales,
        currentLocale: currentLocale ?? this.currentLocale,
        themes: themes,
        currentTheme: currentTheme ?? this.currentTheme,
        scaleList: scaleList,
        currentScale: currentScale ?? this.currentScale,
        dockList: dockList,
        currentDock: currentDock ?? this.currentDock,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        // devToolOptions: devToolOptions,
        // enabledDevToolsFeatures:
        //     enabledDevToolsFeatures ?? this.enabledDevToolsFeatures,
      );
}
