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
  var activeStoryErrorMessage = _getActiveStoryErrorMessage();
  // var sourceMessage =
  //     _replaceGeneratedFileExtensionAndLine(_replaceGeneratedPath(message));
  
  debugPrintSynchronously('''
###error-in-story###
$activeStoryErrorMessage

$message''',
      wrapWidth: wrapWidth);
}

String _replaceGeneratedPath(String message) {
  final regex = RegExp(r'''.dart_tool/build/generated/.+?/''',
      multiLine: true, caseSensitive: true);
  return message.replaceAll(regex, '');
}

String _replaceGeneratedFileExtensionAndLine(String message) {
  final regex = RegExp(r'''.stories.g.dart:(\d+)''',
      multiLine: true, caseSensitive: true);
  return message.replaceAllMapped(regex, (match) {
    final generatedLine = int.parse(match.group(1));
    final sourceLine = generatedLine - 0;
    return '.stories.dart:$sourceLine';
  });
}

String _getActiveStoryErrorMessage() {
  final activeStoryId = activeStory.activeStoryId;
  final metaStories = _storybookData.metaStoriesMap[activeStoryId.pathKey];
  return '''
Error in story:
  ${metaStories.pathFirstPartRemoved} > ${activeStoryId.name}''';
}
