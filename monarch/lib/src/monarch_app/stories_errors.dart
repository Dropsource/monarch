import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'active_story.dart';
import 'monarch_data.dart';

late MonarchData _monarchData;

const errorInStoryMarker = '###error-in-story###';

/// Handles errors caught while running a story. These errors are caught by
/// Monarch, they are *not* caught by the Flutter Framework.
void handleStoryRunError(Object e, Chain chain) {
  var activeStory = _getActiveStoryErrorMessage();
  var folded =
      chain.foldFrames((frame) => frame.package == 'flutter', terse: true);
  debugPrintSynchronously('''
$errorInStoryMarker
══╡ EXCEPTION CAUGHT BY MONARCH ╞═══════════════════════════════════════════════════════════════════
The following message was thrown running a story:
$e

$activeStory

When the exception was thrown, this was the stack:
$folded
════════════════════════════════════════════════════════════════════════════════════════════════════''');
}

/// Handles errors caught by the Flutter Framework. It replaces the original
/// implementation of `debugPrint` with our own.
void handleFlutterFrameworkErrors(MonarchData monarchData) {
  _monarchData = monarchData;

  // Replacing original implementation of `debugPrint` with our own.
  debugPrint = _debugPrintMonarch;

  FlutterError.onError = (FlutterErrorDetails details) {
    // `dumpErrorToConsole` calls `debugPrint`.
    FlutterError.dumpErrorToConsole(details, forceReport: false);
  };
}

void _debugPrintMonarch(String? message, {int? wrapWidth}) {
  var activeStory = _getActiveStoryErrorMessage();

  const stackPrompt = 'When the exception was thrown, this was the stack:';

  var stackIndex = message?.indexOf(stackPrompt) ?? -1;
  String _message;

  if (stackIndex > -1) {
    var preStack = message!.substring(0, stackIndex).trimRight();
    var stack = message.substring(stackIndex);
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
$errorInStoryMarker
$_message''', wrapWidth: wrapWidth);
}

String _getActiveStoryErrorMessage() {
  var activeStoryId = activeStory.value;
  if (activeStoryId == null) {
    return 'There was no active story selected.';
  } else {
    return _getRelevantStoryMessage(activeStoryId);
  }
}

String _getRelevantStoryMessage(StoryId activeStoryId) {
  var metaStories = _monarchData.metaStoriesMap[activeStoryId.pathKey];
  if (metaStories == null) {
    return 'Unexpected - Could not find meta stories for ${activeStoryId.pathKey}';
  }
  return '''
The relevant story is:
  ${metaStories.path} > ${activeStoryId.name}''';
}
