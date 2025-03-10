import 'package:flutter/material.dart';
import 'package:monarch_controller/widgets/components/text.dart';

class NoStoriesFoundWidget extends Center {
  const NoStoriesFoundWidget({super.key})
      : super(
            child: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: TextBody1(
                'story_list.no_stories',
                shouldTranslate: true,
              ),
            ));
}
