import 'dart:async';

import 'package:flutter/material.dart';

import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'device_definitions.dart';
import 'monarch_data.dart';

class StoryView extends StatefulWidget {
  final MonarchData monarchData;
  final String localeKey;

  StoryView({required this.monarchData, required this.localeKey});

  @override
  State<StatefulWidget> createState() {
    return _StoryViewState();
  }
}

class _StoryViewState extends State<StoryView> {
  late DeviceDefinition _device;
  late String _themeId;
  late ThemeData _themeData;

  String? _storyKey;
  StoryFunction? _storyFunction;

  final _streamSubscriptions = <StreamSubscription>[];

  _StoryViewState();

  @override
  void initState() {
    super.initState();

    _setDeviceDefinition();
    _setThemeData();
    _setStoryFunction();

    _streamSubscriptions.addAll([
      activeDevice.stream.listen((_) => setState(_setDeviceDefinition)),
      activeTheme.stream.listen((_) => setState(_setThemeData)),
      activeStory.stream.listen((_) => setState(_setStoryFunction)),
    ]);
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  void _setDeviceDefinition() => _device = activeDevice.value;

  void _setThemeData() {
    _themeData = activeTheme.value.theme!;
    _themeId = activeTheme.value.id;
  }

  void _setStoryFunction() {
    final activeStoryId = activeStory.value;

    if (activeStoryId == null) {
      _storyKey = null;
      _storyFunction = null;
    } else {
      final metaStories =
          widget.monarchData.metaStoriesMap[activeStoryId.pathKey]!;
      _storyKey = activeStoryId.storyKey;
      _storyFunction = metaStories.storiesMap[activeStoryId.name];
    }
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
          data: _themeData.copyWith(
              platform: _device.targetPlatform,
              // Override visualDensity to use the one set for mobile platform:
              // - https://github.com/flutter/flutter/pull/66370
              // - https://github.com/flutter/flutter/issues/63788
              // Otherwise, flutter desktop uses VisualDensity.compact.
              visualDensity: VisualDensity.standard),
          child: Container(
              color: _themeData.scaffoldBackgroundColor,
              child: _storyFunction!()));

      // If we need to pass the selected device's `devicePixelRatio`, then we
      // can wrap the Container above with a MediaQuery like:
      // ```
      // MediaQuery(
      //   data: MediaQuery.of(context).copyWith(devicePixelRatio: _device.devicePixelRatio),
      //   child: Container(...)
      // ```
      // Which should copy the MediaQuery from the MaterialApp widget and any changes
      // we make to [MonarchBinding.window].
      // However, if we are rendering the story on a desktop window, then using
      // the device pixel ratio of a different device may render unexpected results
      // for the user. The device pixel ratio of a desktop window and a mobile device
      // may be different.
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
