import 'package:flutter/material.dart';

import 'story_view.dart';
import 'monarch_data.dart';

class StoryApp extends StatelessWidget {
  final MonarchData monarchData;

  StoryApp({this.monarchData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Story',
        home: Scaffold(body: StoryView(monarchData: monarchData)));
  }
}
