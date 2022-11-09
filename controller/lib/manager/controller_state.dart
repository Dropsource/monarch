import 'package:monarch_definitions/monarch_definitions.dart';
import '../data/stories.dart';

class ControllerState {
  final bool isReady;
  final String packageName;
  final List<StoryGroup> storyGroups;
  final Set<String> collapsedGroupKeys;
  final StoryId? currentStoryId;

  final DeviceDefinition currentDevice;
  final List<DeviceDefinition> devices;

  final String currentLocale;
  final List<String> locales;

  final MetaThemeDefinition currentTheme;
  final List<MetaThemeDefinition> standardThemes;
  final List<MetaThemeDefinition> userThemes;

  final StoryScaleDefinition currentScale;

  final List<StoryScaleDefinition> scaleList;

  final DockDefinition currentDock;
  final List<DockDefinition> dockList;

  final double textScaleFactor;
  final Map<String, bool> visualDebugFlags;

  List<MetaThemeDefinition> get allThemes => standardThemes + userThemes;
  int get storyCount => storyGroups.fold<int>(
      0, (previousValue, element) => previousValue + element.stories.length);

  ControllerState({
    required this.isReady,
    this.packageName = '',
    this.storyGroups = const [],
    this.currentStoryId,
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
    required this.collapsedGroupKeys,
  });

  factory ControllerState.init() => ControllerState(
        isReady: false,
        collapsedGroupKeys: {},
        devices: [defaultDeviceDefinition],
        currentDevice: defaultDeviceDefinition,
        locales: [defaultLocale],
        currentLocale: defaultLocale,
        currentTheme: defaultThemeDefinition,
        standardThemes: [defaultThemeDefinition],
        userThemes: [],
        currentDock: defaultDockDefinition,
        currentScale: defaultScaleDefinition,
        dockList: dockDefinitions,
        scaleList: [defaultScaleDefinition],
        visualDebugFlags: defaultVisualDebugFlags,
        textScaleFactor: 1.0,
      );

  ControllerState copyWith({
    StoryId? currentStoryId,
    String? packageName,
    List<StoryGroup>? storyGroups,
    bool? isReady,
    List<DeviceDefinition>? devices,
    DeviceDefinition? currentDevice,
    String? currentLocale,
    List<String>? locales,
    MetaThemeDefinition? currentTheme,
    List<MetaThemeDefinition>? standardThemes,
    List<MetaThemeDefinition>? userThemes,
    StoryScaleDefinition? currentScale,
    DockDefinition? currentDock,
    double? textScaleFactor,
    Map<String, bool>? visualDebugFlags,
    List<StoryScaleDefinition>? scaleList,
  }) =>
      ControllerState(
        currentStoryId: currentStoryId ?? this.currentStoryId,
        storyGroups: storyGroups ?? this.storyGroups,
        isReady: isReady ?? this.isReady,
        devices: devices ?? this.devices,
        currentDevice: currentDevice ?? this.currentDevice,
        locales: locales ?? this.locales,
        currentLocale: currentLocale ?? this.currentLocale,
        currentTheme: currentTheme ?? this.currentTheme,
        standardThemes: standardThemes ?? this.standardThemes,
        userThemes: userThemes ?? this.userThemes,
        scaleList: scaleList ?? this.scaleList,
        currentScale: currentScale ?? this.currentScale,
        dockList: dockList,
        currentDock: currentDock ?? this.currentDock,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        visualDebugFlags: visualDebugFlags ?? this.visualDebugFlags,
        packageName: packageName ?? this.packageName,
        collapsedGroupKeys: collapsedGroupKeys,
      );
}
