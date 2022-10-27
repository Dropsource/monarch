import 'package:monarch_definitions/monarch_definitions.dart';

import 'active_value.dart';

class ActiveStory extends ActiveValue<StoryId?> {
  StoryId? _activeStoryId;

  @override
  StoryId? get value => _activeStoryId;

  @override
  void setValue(StoryId? newValue) {
    _activeStoryId = newValue;
  }

  @override
  String get valueSetMessage => value == null
      ? 'active story id reset'
      : 'active story id set: ${value!}';
}

final activeStory = ActiveStory();
