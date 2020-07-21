import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'device_definitions.dart';
import 'monarch_data.dart';

class StoryView extends StatefulWidget {
  final MonarchData monarchData;

  StoryView({this.monarchData});

  @override
  State<StatefulWidget> createState() {
    return _StoryViewState();
  }
}

class _StoryViewState extends State<StoryView> {
  DeviceDefinition _device;
  String _themeId;
  ThemeData _themeData;

  String _storyKey;
  StoryFunction _storyFunction;

  StreamSubscription _activeDeviceSubscription;
  StreamSubscription _activeThemeSubscription;
  StreamSubscription _activeStorySubscription;

  _StoryViewState();

  @override
  void initState() {
    super.initState();

    _setDeviceDefinition();
    _activeDeviceSubscription = activeDevice.activeDeviceStream
        .listen((_) => setState(_setDeviceDefinition));

    _setThemeData();
    _activeThemeSubscription = activeTheme.activeMetaThemeStream
        .listen((_) => setState(_setThemeData));

    _activeStorySubscription = activeStory.activeStoryChangeStream
        .listen((_) => setState(_setStoryFunction));
  }

  void _setDeviceDefinition() {
    _device = activeDevice.activeDevice;
  }

  void _setThemeData() {
    _themeData = activeTheme.activeMetaTheme.theme;
    _themeId = activeTheme.activeMetaTheme.id;
  }

  void _setStoryFunction() {
    final activeStoryId = activeStory.activeStoryId;

    if (activeStoryId == null) {
      _storyKey = null;
      _storyFunction = null;
    } else {
      final metaStories =
          widget.monarchData.metaStoriesMap[activeStoryId.pathKey];
      _storyKey = activeStory.activeStoryId.storyKey;
      _storyFunction = metaStories.storiesMap[activeStoryId.name];
    }
  }

  @override
  void dispose() {
    _activeThemeSubscription?.cancel();
    _activeStorySubscription?.cancel();
    _activeDeviceSubscription?.cancel();
    super.dispose();
  }

  String get keyValue => '$_storyKey|$_themeId|${_device.id}';

  @override
  Widget build(BuildContext context) {
    ArgumentError.checkNotNull(_device, '_device');
    ArgumentError.checkNotNull(_themeId, '_themeId');
    ArgumentError.checkNotNull(_themeData, '_themeData');

    if (_storyFunction == null) {
      return Center(child: Text('Please select a story'));
    } else {
      return Theme(
          key: ObjectKey(keyValue),
          child: MediaQuery(
              data: MediaQueryData(
                  size: Size(_device.logicalResolution.width,
                      _device.logicalResolution.height),
                  devicePixelRatio: _device.devicePixelRatio),
              child: _storyFunction()),
          data: _themeData.copyWith(platform: _device.targetPlatform));
    }
  }
}
