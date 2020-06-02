import 'package:flutter/foundation.dart';

import 'active_story.dart';
import 'storybook_data.dart';

StorybookData _storybookData;

void setUpStoriesErrors(StorybookData storybookData) {
  _storybookData = storybookData;

  // Replacing original implementation of `debugPrint` with our own.
  // `dumpErrorToConsole` calls `debugPrint`.
  debugPrint = _debugPrintStorybook;

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  };
}

void _debugPrintStorybook(String message, {int wrapWidth}) {
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
  final metaStories = _storybookData.metaStoriesMap[activeStoryId.pathKey];
  return '''
The relevant story is:
  ${metaStories.path} > ${activeStoryId.name}''';
}
