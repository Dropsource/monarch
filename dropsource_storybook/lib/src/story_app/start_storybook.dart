import 'package:flutter/material.dart';

import 'package:dropsource_storybook_utils/log.dart';
import 'package:dropsource_storybook_utils/log_config.dart';

import 'channel_methods_sender.dart';
import 'channel_methods_receiver.dart';
import 'stories_errors.dart';
import 'story_app.dart';
import 'storybook_data.dart';

final logger = Logger('Start');

void startStorybook(String packageName, Map<String, StoriesData> storybookDataMap) {
  _setUpLog();

  logger.finest('Starting storybook flutter app');

  final storybookData = StorybookData(packageName, storybookDataMap);
  setUpStoriesErrors(storybookData);
  runApp(StoryApp(storybookData: storybookData));

  receiveChannelMethodCalls();
  _sendInitialChannelMethodCalls(storybookData);
}

void _setUpLog() {
  defaultLogLevel = LogLevel.ALL;
  logToConsole(printTimestamp: false, printLoggerName: true);
}

void _sendInitialChannelMethodCalls(StorybookData storybookData) async {
  await channelMethodsSender.sendPing();
  await channelMethodsSender.sendStorybookData(storybookData);
  await channelMethodsSender.sendReadySignal();
}