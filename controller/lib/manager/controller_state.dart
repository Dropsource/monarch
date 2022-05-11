
import 'package:monarch_controller/data/device_definitions.dart';
import 'package:monarch_controller/data/dock_definition.dart';
import 'package:monarch_controller/data/monarch_data.dart';
import 'package:monarch_controller/data/definitions.dart'
    as defs;
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/data/story_scale_definitions.dart';
import 'package:monarch_controller/data/visual_debug_flags.dart';


class ControllerState {
  final bool isReady;
  final String packageName;
  final List<StoryGroup> storyGroups;
  final String? activeStoryKey;

  final DeviceDefinition currentDevice;
  final List<DeviceDefinition> devices;

  final String currentLocale;
  final List<String> locales;

  final MetaTheme currentTheme;
  final List<MetaTheme> standardThemes;
  final List<MetaTheme> userThemes;

  final StoryScaleDefinition currentScale;

  final List<StoryScaleDefinition> scaleList;

  final DockDefinition currentDock;
  final List<DockDefinition> dockList;

  final double textScaleFactor;
  final List<VisualDebugFlag> visualDebugFlags;

  List<MetaTheme> get allThemes => standardThemes + userThemes;

  ControllerState({
    required this.isReady,
    this.packageName = '',
    this.storyGroups = const [],
    this.activeStoryKey,
    required this.devices,
    required this.currentDevice,
    required this.locales,
    required this.currentLocale,
    required this.standardThemes,
    required this.userThemes,
    required this.currentTheme,
    required this.currentDock,
    required this.currentScale,
    required this.dockList,
    required this.scaleList,
    required this.textScaleFactor,
    required this.visualDebugFlags,
  });

  factory ControllerState.init() => ControllerState(
        isReady: false,
        devices: [defaultDeviceDefinition],
        currentDevice: defaultDeviceDefinition,
        locales: [defs.defaultLocale],
        currentLocale: defs.defaultLocale,
        standardThemes: [defs.defaultTheme],
        userThemes: [],
        currentTheme: defs.defaultTheme,
        currentDock: defs.defaultDock,
        currentScale: defaultScaleDefinition,
        dockList: defs.dockList,
        scaleList: [defaultScaleDefinition],
        visualDebugFlags: defs.devToolsOptions,
        textScaleFactor: 1.0,
      );

  ControllerState copyWith({
    String? activeStoryKey,
    String? packageName,
    List<StoryGroup>? storyGroups,
    bool? isReady,
    List<DeviceDefinition>? devices,
    DeviceDefinition? currentDevice,
    String? currentLocale,
    List<String>? locales,
    MetaTheme? currentTheme,
    List<MetaTheme>? standardThemes,
    List<MetaTheme>? userThemes,
    StoryScaleDefinition? currentScale,
    DockDefinition? currentDock,
    double? textScaleFactor,
    List<VisualDebugFlag>? visualDebugFlags,
    List<StoryScaleDefinition>? scaleList,
  }) =>
      ControllerState(
        activeStoryKey: activeStoryKey ?? this.activeStoryKey,
        storyGroups: storyGroups ?? this.storyGroups,
        isReady: isReady ?? this.isReady,
        devices: devices ?? this.devices,
        currentDevice: currentDevice ?? this.currentDevice,
        locales: locales ?? this.locales,
        currentLocale: currentLocale ?? this.currentLocale,
        standardThemes: standardThemes ?? this.standardThemes,
        userThemes: userThemes ?? this.userThemes,
        currentTheme: currentTheme ?? this.currentTheme,
        scaleList: scaleList ?? this.scaleList,
        currentScale: currentScale ?? this.currentScale,
        dockList: dockList,
        currentDock: currentDock ?? this.currentDock,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        visualDebugFlags: visualDebugFlags ?? this.visualDebugFlags,
        packageName: packageName ?? this.packageName,
      );
}
