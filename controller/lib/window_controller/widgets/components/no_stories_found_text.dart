import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';

class NoStoriesFoundWidget extends Center {
  const NoStoriesFoundWidget({Key? key})
      : super(
            key: key,
            child: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: TextBody1(
                'story_list.no_stories',
                shouldTranslate: true,
              ),
            ));
}
