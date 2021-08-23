import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'active_story_scale.dart';
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
  late double _storyScale;
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

    _setStoryScale();
    _setDeviceDefinition();
    _setThemeData();
    _setStoryFunction();

    _streamSubscriptions.addAll([
      activeStoryScale.stream.listen((_) => _popAndSetState(_setStoryScale)),
      activeDevice.stream.listen((_) => _popAndSetState(_setDeviceDefinition)),
      activeTheme.stream.listen((_) => _popAndSetState(_setThemeData)),
      activeStory.stream.listen((_) => _popAndSetState(_setStoryFunction)),
    ]);
  }

  void _popAndSetState(void Function() fn) {
    Navigator.popUntil(context,
        ModalRoute.withName(PlatformDispatcher.instance.defaultRouteName));
    setState(fn);
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  void _setStoryScale() => _storyScale = activeStoryScale.value;

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
      '$_storyKey|$_themeId|${_device.id}|${widget.localeKey}|$_storyScale';

  @override
  Widget build(BuildContext context) {
    if (_storyFunction == null) {
      return ScaleScaffold(
          scale: _storyScale, body: CenteredText('Please select a story'));
    } else {
      return ScaleScaffold(
        key: ValueKey(keyValue),
        scale: _storyScale,
        body: Theme(
            data: _themeData.copyWith(
                platform: _device.targetPlatform,
                // Override visualDensity to use the one set for mobile platform:
                // - https://github.com/flutter/flutter/pull/66370
                // - https://github.com/flutter/flutter/issues/63788
                // Otherwise, flutter desktop uses VisualDensity.compact.
                visualDensity: VisualDensity.standard),
            child: Container(
                color: _themeData.scaffoldBackgroundColor,
                child: _storyFunction!())),
      );

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

class ScaleScaffold extends StatelessWidget {
  final double scale;
  final Widget? body;

  ScaleScaffold({Key? key, required this.scale, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: scale,
        alignment: Alignment.topLeft,
        child: Scaffold(body: body));
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

class SimpleMessageView extends StatefulWidget {
  final String message;

  SimpleMessageView({required this.message});

  @override
  State<StatefulWidget> createState() {
    return _SimpleMessageViewState();
  }
}

class _SimpleMessageViewState extends State<SimpleMessageView> {
  late double _storyScale;
  final _streamSubscriptions = <StreamSubscription>[];

  _SimpleMessageViewState();

  @override
  void initState() {
    super.initState();

    _setStoryScale();

    _streamSubscriptions
        .add(activeStoryScale.stream.listen((_) => setState(_setStoryScale)));
  }

  void _setStoryScale() => _storyScale = activeStoryScale.value;

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleScaffold(
        scale: _storyScale, body: CenteredText(widget.message));
  }
}
