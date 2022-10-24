import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'active_story_error.dart';
import 'project_data_manager.dart';
import 'project_data.dart';
import 'story_error_view.dart';

final _logger = Logger('MonarchStoryView');

class MonarchStoryView extends StatefulWidget {
  MonarchStoryView();

  @override
  State<StatefulWidget> createState() {
    return _MonarchStoryViewState();
  }
}

class _MonarchStoryViewState extends State<MonarchStoryView> {
  late DeviceDefinition _device;
  late ThemeData _themeData;

  StoryFunction? _storyFunction;

  String? _storyErrorMessage;

  final _streamSubscriptions = <StreamSubscription>[];

  _MonarchStoryViewState();

  @override
  void initState() {
    super.initState();

    _setDeviceDefinition();
    _setThemeData();
    _setStoryFunction();
    _setStoryErrorMessage();

    _streamSubscriptions.addAll([
      activeDevice.stream.listen((_) => _popAndSetState(_setDeviceDefinition)),
      activeTheme.stream.listen((_) => _popAndSetState(_setThemeData)),
      activeStory.stream.listen((_) => _popAndSetState(_setStoryFunction)),
      activeStoryError.stream
          .listen((_) => _popAndSetState(_setStoryErrorMessage))
    ]);
  }

  void _popAndSetState(void Function() fn) {
    try {
      Navigator.popUntil(context,
          ModalRoute.withName(PlatformDispatcher.instance.defaultRouteName));
    } on AssertionError catch (e, s) {
      _logger.warning(
          'AssertionError while popping to default route, '
          'which could happen if there was a previous FlutterError on a story.',
          e,
          s);
    }
    setState(fn);
  }

  @override
  void dispose() {
    for (var s in _streamSubscriptions) {
      s.cancel();
    }
    super.dispose();
  }

  void _setDeviceDefinition() => _device = activeDevice.value;

  void _setThemeData() {
    _themeData = activeTheme.value.theme!;
  }

  void _setStoryFunction() {
    final activeStoryId = activeStory.value;

    if (activeStoryId == null) {
      _storyFunction = null;
    } else {
      final metaStories =
          projectDataManager.data!.metaStoriesMap[activeStoryId.storiesMapKey]!;
      _storyFunction = metaStories.storiesMap[activeStoryId.storyName];
    }
  }

  void _setStoryErrorMessage() => _storyErrorMessage = activeStoryError.value;

  @override
  Widget build(BuildContext context) {
    if (_storyFunction == null) {
      return MonarchSimpleMessageView(message: 'Please select a story');
    }
    if (_storyErrorMessage != null) {
      return MonarchStoryErrorView(message: _storyErrorMessage!);
    }

    try {
      var story = _storyFunction!();
      return _buildStory(story);
    } on NoSuchMethodError {
      return MonarchSimpleMessageView(message: 'Please select a story');
    }
  }

  Widget _buildStory(Widget story) {
    return Scaffold(
      key: UniqueKey(),
      body: Theme(
          data: _themeData.copyWith(
              platform: _device.targetPlatform == MonarchTargetPlatform.android
                  ? TargetPlatform.android
                  : TargetPlatform.iOS,
              // Override visualDensity to use the one set for mobile platform:
              // - https://github.com/flutter/flutter/pull/66370
              // - https://github.com/flutter/flutter/issues/63788
              // Otherwise, flutter desktop uses VisualDensity.compact.
              visualDensity: VisualDensity.standard),
          child: Container(
              color: _themeData.scaffoldBackgroundColor, child: story)),
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

class MonarchSimpleMessageView extends StatelessWidget {
  final String message;

  MonarchSimpleMessageView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MonarchCenteredText(message));
  }
}

class MonarchCenteredText extends StatelessWidget {
  MonarchCenteredText(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(padding: EdgeInsets.all(10), child: Text(data)));
  }
}
