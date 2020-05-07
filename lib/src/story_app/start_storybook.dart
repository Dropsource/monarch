import 'package:flutter/material.dart';

import 'package:dropsource_storybook_utils/log.dart';

import '../storybook_data.dart';
import 'channel_methods_sender.dart';
import 'channel_methods_receiver.dart';
import 'story_app.dart';

final logger = Logger('Start');

void startStorybook(String packageName, Map<String, StoriesData> storybookDataMap) {
  _setUpLog();
  _setUpFlutterErrors();

  logger.finest('Starting storybook flutter app');

  final storybookData = StorybookData(packageName, storybookDataMap);
  runApp(StoryApp(storybookData: storybookData));

  receiveChannelMethodCalls();
  _sendInitialChannelMethodCalls(storybookData);
}

/// The defaultLogLevel may be reset by the platform, see channel_methods_receiver.dart
void _setUpLog() {
  defaultLogLevel = LogLevel.ALL;
  logToConsole(printTimestamp: false, printLoggerName: true);
}

void _setUpFlutterErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  };
}

void _sendInitialChannelMethodCalls(StorybookData storybookData) async {
  await channelMethodsSender.sendPing();
  await channelMethodsSender.sendStorybookData(storybookData);
  await channelMethodsSender.sendReadySignal();
}