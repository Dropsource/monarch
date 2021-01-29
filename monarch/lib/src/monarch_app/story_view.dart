import 'dart:async';

import 'package:flutter/material.dart';

import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'active_text_scale_factor.dart';
import 'device_definitions.dart';
import 'monarch_data.dart';

class StoryView extends StatefulWidget {
  final MonarchData monarchData;
  final String localeKey;

  StoryView({@required this.monarchData, @required this.localeKey});

  @override
  State<StatefulWidget> createState() {
    return _StoryViewState();
  }
}

class _StoryViewState extends State<StoryView> {
  DeviceDefinition _device;
  String _themeId;
  ThemeData _themeData;
  double _textScaleFactor;

  String _storyKey;
  StoryFunction _storyFunction;

  final _streamSubscriptions = <StreamSubscription>[];

  _StoryViewState();

  @override
  void initState() {
    super.initState();

    _setDeviceDefinition();
    _setThemeData();
    _setStoryFunction();
    _setTextScaleFactor();

    _streamSubscriptions.addAll([
      activeDevice.activeDeviceStream
          .listen((_) => setState(_setDeviceDefinition)),
      activeTheme.activeMetaThemeStream.listen((_) => setState(_setThemeData)),
      activeStory.activeStoryChangeStream
          .listen((_) => setState(_setStoryFunction)),
      activeTextScaleFactor.activeTextScaleFactorStream
          .listen((_) => setState(_setTextScaleFactor))
    ]);
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
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

  void _setTextScaleFactor() {
    _textScaleFactor = activeTextScaleFactor.activeTextScaleFactor;
  }

  String get keyValue =>
      '$_storyKey|$_themeId|${_device.id}|${widget.localeKey}';

  @override
  Widget build(BuildContext context) {
    ArgumentError.checkNotNull(_device, '_device');
    ArgumentError.checkNotNull(_themeId, '_themeId');
    ArgumentError.checkNotNull(_themeData, '_themeData');

    if (_storyFunction == null) {
      return CenteredText('Please select a story');
    } else {
      return Theme(
          key: ObjectKey(keyValue),
          child: MediaQuery(
              data: MediaQueryData(
                  textScaleFactor: _textScaleFactor,
                  size: Size(_device.logicalResolution.width,
                      _device.logicalResolution.height),
                  devicePixelRatio: _device.devicePixelRatio),
              child: Container(
                  color: _themeData.scaffoldBackgroundColor,
                  child: _storyFunction())),
          data: _themeData.copyWith(platform: _device.targetPlatform));
    }
  }
}

class CenteredText extends StatelessWidget {
  CenteredText(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(padding: EdgeInsets.all(10), child: Text(data)));
  }
}
