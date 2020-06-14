import 'dart:async';

import 'package:flutter/material.dart';

import 'story_view.dart';
import 'storybook_data.dart';
import 'active_story.dart';

// class StoryApp_ extends StatelessWidget {
//   final StorybookData storybookData;

//   StoryApp_({this.storybookData});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Story',
//         home: Scaffold(body: StoryView(storybookData: storybookData)));
//   }
// }

class StoryApp extends StatefulWidget {
  final StorybookData storybookData;

  StoryApp({this.storybookData});

  @override
  State<StatefulWidget> createState() {
    return _StoryAppState();
  }
}

class _StoryAppState extends State<StoryApp> {
  String _storyKey;
  StoryFunction _storyFunction;
  StreamSubscription _activeStorySubscription;

  _StoryAppState();

  @override
  void initState() {
    super.initState();
    _activeStorySubscription = activeStory.activeStoryChangeStream
        .listen((_) => setState(_setStoryFunction));
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

    Navigator.pushNamed(context, '__ds__');
  }

  @override
  void dispose() {
    _activeStorySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story',
      home: Scaffold(body: SelectStory()),
      onGenerateRoute: (_) {
        if (_storyFunction == null) {
          return MaterialPageRoute(builder: (_) => SelectStory());
        } else {
          return MaterialPageRoute(
              builder: (_) =>
                  StoryView(storyKey: _storyKey, child: _storyFunction()));
        }
      },
    );
  }
}

class SelectStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Please select a story'));
  }
}
