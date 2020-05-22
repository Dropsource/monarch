import 'package:flutter/material.dart';

import 'story_view.dart';
import 'storybook_data.dart';

class StoryApp extends StatelessWidget {
  final StorybookData storybookData;

  StoryApp({this.storybookData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Story',
        home: Scaffold(body: StoryView(storybookData: storybookData)));
  }
}
