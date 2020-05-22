import 'dart:async';

import 'package:flutter/widgets.dart';

import 'active_story.dart';
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
  StoryFunction _storyFunction;
  StreamSubscription _activeStorySubscription;

  _StoryViewState();

  @override
  void initState() {
    super.initState();
    _activeStorySubscription = activeStory.activeStoryChangeStream
        .listen((_) => setState(_setStoryFunction));
  }

  void _setStoryFunction() {
    final activeStoryId = activeStory.activeStoryId;

    if (activeStoryId == null) {
      _storyFunction = null;
    } else {
      final storiesData = widget.storybookData.storiesDataMap[activeStoryId.pathKey];
      _storyFunction = storiesData.storiesMap[activeStoryId.name];
    }
  }

  @override
  void dispose() {
    _activeStorySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_storyFunction == null) {
      return Center(child: Text('Please select a story'));
    }
    else {
      return _storyFunction();
    }
  }
}