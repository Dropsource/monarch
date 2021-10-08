import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'active_story.dart';
import 'log_level.dart';
import 'monarch_data.dart';

late MonarchData _monarchData;
int _uncaughtErrorCount = 0;
const errorLineMarker = '##err-line##';

/// Handles errors not caught by the Flutter Framework. These are uncaught
/// errors, usually asynchronous errors thrown by user code.
///
/// The first time this is called, it prints a verbose exception message.
///
/// Subsequent calls only print the [error] object, which is usually a single
/// line, unless we are running in verbose mode.
///
/// Call [resetErrorCount] to cause this function to print the next error
/// as if it was the first time.
void handleUncaughtError(Object error, Chain chain) {
  if (_uncaughtErrorCount == 0 || isVerbose) {
    var prompt = activeStory.value == null
        ? 'The following message was thrown while a story was not selected'
        : 'The following message was thrown while a story was selected:';

    var activeStoryMsg = _getActiveStoryErrorMessage();
    var folded =
        chain.foldFrames((frame) => frame.package == 'flutter', terse: true);
    _debugPrintThrottledError('''
══╡ EXCEPTION CAUGHT BY MONARCH ╞═══════════════════════════════════════════════════════════════════
$prompt
$error

$activeStoryMsg

When the exception was thrown, this was the stack:
$folded
════════════════════════════════════════════════════════════════════════════════════════════════════''');
  } else {
    _debugPrintThrottledError('Another exception was thrown: $error');
  }
  _uncaughtErrorCount += 1;
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
  if (message == null) {
    debugPrintThrottled(message, wrapWidth: wrapWidth);
  } else if (message.startsWith('Another exception was thrown')) {
    _debugPrintThrottledError(message, wrapWidth: wrapWidth);
  } else {
    var activeStoryMsg = _getActiveStoryErrorMessage();
    const stackPrompt = 'When the exception was thrown, this was the stack:';
    var stackIndex = message.indexOf(stackPrompt);

    if (stackIndex > -1) {
      var preStack = message.substring(0, stackIndex).trimRight();
      var stack = message.substring(stackIndex);
      _debugPrintThrottledError('''
$preStack

$activeStoryMsg

$stack''', wrapWidth: wrapWidth);
    } else {
      _debugPrintThrottledError('''
$message

$activeStoryMsg''', wrapWidth: wrapWidth);
    }
  }
}

/// Prints the [message] to stdout using [debugPrintThrottled] which throttles
/// the printing of messages. [debugPrintThrottled] also splits the message
/// and prints one line at a time.
///
/// It prefixes each line of [message] with a marker
/// so the Monarch CLI can display the message to the user.
void _debugPrintThrottledError(String message, {int? wrapWidth}) {
  var lines = message.trimRight().split('\n');
  var buffer = StringBuffer();

  for (var line in lines) {
    buffer.writeln('$errorLineMarker$line');
  }
  buffer.writeln(errorLineMarker);

  debugPrintThrottled(buffer.toString(), wrapWidth: wrapWidth);
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

void resetErrorCount() {
  _uncaughtErrorCount = 0;
  FlutterError.resetErrorCount();
}
