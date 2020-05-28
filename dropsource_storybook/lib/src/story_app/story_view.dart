import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'active_story.dart';
import 'active_theme.dart';
import 'storybook_data.dart';

class StoryView extends StatefulWidget {
  final StorybookData storybookData;

  StoryView({this.storybookData});

  @override
  State<StatefulWidget> createState() {
    return _StoryViewState();
  }
}

class _StoryViewState extends State<StoryView> {
  String _storyKey;
  StoryFunction _storyFunction;

  String _themeId;
  ThemeData _themeData;

  StreamSubscription _activeStorySubscription;
  StreamSubscription _activeThemeSubscription;

  _StoryViewState();

  @override
  void initState() {
    super.initState();

    _setThemeData();
    _activeThemeSubscription = activeTheme.activeMetaThemeStream
        .listen((_) => setState(_setThemeData));

    _activeStorySubscription = activeStory.activeStoryChangeStream
        .listen((_) => setState(_setStoryFunction));
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
          widget.storybookData.metaStoriesMap[activeStoryId.pathKey];
      _storyKey = activeStory.activeStoryId.storyKey;
      _storyFunction = metaStories.storiesMap[activeStoryId.name];
    }
  }

  @override
  void dispose() {
    _activeThemeSubscription?.cancel();
    _activeStorySubscription?.cancel();
    super.dispose();
  }

  String get keyValue => '$_storyKey|$_themeId';

  @override
  Widget build(BuildContext context) {
    if (_storyFunction == null) {
      return Center(child: Text('Please select a story'));
    } else {
      return Theme(
          key: ObjectKey(keyValue),
          child: _storyFunction(),
          data: _themeData);
    }
  }
}
