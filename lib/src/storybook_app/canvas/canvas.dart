import 'dart:async';

import '../color_palette.dart';
import '../../device_definitions.dart';
import 'package:flutter/widgets.dart';

import '../../story_app/active_story.dart';
import '../../storybook_data.dart';
import 'story_resolution_view.dart';
import 'ruler.dart';

class Canvas extends StatefulWidget {
  final StorybookData storybookData;

  Canvas({this.storybookData});

  @override
  State<StatefulWidget> createState() {
    return _CanvasState();
  }
}

class _CanvasState extends State<Canvas> {
  StoryFunction _storyFunction;
  StreamSubscription _activeStorySubscription;

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
      final storybookData = widget.storybookData.storiesDataMap[activeStoryId.pathKey];
      _storyFunction = storybookData.storiesMap[activeStoryId.name];
    }
  }

  @override
  void dispose() {
    _activeStorySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorPalette.powderedSnow),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return _buildHorizontalRuler(context, constraints);
            }),
            Expanded(child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return _buildVerticalRulerAndStoryView(context, constraints);
            }))
          ]),
    );
  }

  Widget _buildHorizontalRuler(
      BuildContext context, BoxConstraints constraints) {
    const rulerShortSideLength = RulerSegment.shortSideLength;
    return Row(children: <Widget>[
      Container(width: rulerShortSideLength, height: rulerShortSideLength),
      SizedOverflowBox(
          size: Size(constraints.maxWidth - rulerShortSideLength,
              rulerShortSideLength),
          alignment: Alignment.topLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Ruler(
                  start: -50,
                  end: 0,
                  segmentLength: 50,
                  direction: RulerDirection.horizontal),
              Ruler(
                  start: 0,
                  end: 1600,
                  segmentLength: 100,
                  direction: RulerDirection.horizontal)
            ],
          ))
    ]);
  }

  Widget _buildVerticalRulerAndStoryView(
      BuildContext context, BoxConstraints constraints) {
    const rulerShortSideLength = RulerSegment.shortSideLength;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      SizedOverflowBox(
          size: Size(rulerShortSideLength, constraints.maxHeight),
          alignment: Alignment.topLeft,
          child: Wrap(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Ruler(
                    start: -50,
                    end: 0,
                    segmentLength: 50,
                    direction: RulerDirection.vertical),
                Ruler(
                    start: 0,
                    end: 1600,
                    segmentLength: 100,
                    direction: RulerDirection.vertical)
              ],
            )
          ])),
      Expanded(
          child: Container(
              // decoration: BoxDecoration(color: ColorPalette.powderedSnow),
              child: _buildStoryView()))
    ]);
  }

  Widget _buildStoryView() {
    if (_storyFunction == null) {
      return Container();
    } else {
      return Stack(
        children: <Widget>[
          Positioned(
              left: 50,
              top: 50,
              child: StoryResolutionView(
                  resolution: deviceDefinitions[0].logicalResolution,
                  storyFunction: _storyFunction))
        ],
      );
    }
  }
}
