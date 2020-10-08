import 'package:flutter/foundation.dart';

import 'active_story.dart';
import 'monarch_data.dart';

MonarchData _monarchData;

void setUpStoriesErrors(MonarchData monarchData) {
  _monarchData = monarchData;

  // Replacing original implementation of `debugPrint` with our own.
  // `dumpErrorToConsole` calls `debugPrint`.
  debugPrint = _debugPrintMonarch;

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  };
}

void _debugPrintMonarch(String message, {int wrapWidth}) {
  var activeStory = _getActiveStoryErrorMessage();

  const stackPrompt = 'When the exception was thrown, this was the stack:';

  final stackIndex = message.indexOf(stackPrompt);
  String _message;

  if (stackIndex > -1) {
    final preStack = message.substring(0, stackIndex).trimRight();
    final stack = message.substring(stackIndex);
    _message = '''
$preStack

$activeStory

$stack''';
  } else {
    _message = '''
$message
$activeStory''';
  }

  debugPrintSynchronously('''
###error-in-story###
$_message''', wrapWidth: wrapWidth);
}

String _getActiveStoryErrorMessage() {
  final activeStoryId = activeStory.activeStoryId;
  if (activeStoryId == null) {
    return 'There was no active story selected.';
  } else {
    final metaStories = _monarchData.metaStoriesMap[activeStoryId.pathKey];
    if (metaStories == null) {
      return 'Unexpected - Could not find meta stories for ${activeStoryId.pathKey}';
    }
    return '''
The relevant story is:
  ${metaStories.path} > ${activeStoryId.name}''';
  }
}
