import 'dart:ui';

import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';

abstract class WindowControllerState {
  final bool active;

  WindowControllerState({required this.active});
}

class ConnectedWindowControllerState extends WindowControllerState {
  final MonarchData monarchData;
  final String? activeStoryName;

  final String currentDevice;
  final List<String> devices;

  final Locale currentLocale;
  final MetaTheme currentTheme;

  ConnectedWindowControllerState({
    required bool active,
    required this.monarchData,
    this.activeStoryName,
    required this.devices,
    required this.currentDevice,
    required this.currentLocale,
    required this.currentTheme,
  }) : super(active: active);

  factory ConnectedWindowControllerState.test() =>
      ConnectedWindowControllerState(
          devices: [
            'iPhone 13',
            'iPhone 13 Pro Max',
            'Samsung S22',
          ],
          currentDevice: 'iPhone 13',
          active: true,
          currentLocale: const Locale('en'),
          currentTheme: MetaTheme(
            'theme_id',
            'Default',
            null,
            true,
          ),
          monarchData: MonarchData(
            'test_package_name',
            [
              MetaLocalization(
                [
                  const Locale('en',),
                  const Locale('es'),
                ],
                null,
                'locale_delegate_class_name',
              ),
            ],
            [
              MetaTheme(
                'theme_id',
                'Default',
                null,
                true,
              ),
              MetaTheme(
                'other_theme_id',
                'Material Light',
                null,
                false,
              ),
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
          activeStoryName: null);

  ConnectedWindowControllerState copyWith({
    String? activeStoryName,
    MonarchData? monarchData,
    bool? active,
    String? currentDevice,
    Locale? currentLocale,
    MetaTheme? currentTheme,
  }) =>
      ConnectedWindowControllerState(
        activeStoryName: activeStoryName ?? this.activeStoryName,
        monarchData: monarchData ?? this.monarchData,
        active: active ?? this.active,
        currentDevice: currentDevice ?? this.currentDevice,
        devices: devices,
        currentLocale: currentLocale ?? this.currentLocale,
        currentTheme: currentTheme ?? this.currentTheme,
      );
}
