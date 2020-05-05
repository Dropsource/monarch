import 'package:flutter/material.dart';

import 'package:dropsource_storybook_utils/log.dart';

import '../device_definitions.dart';
import '../storybook_data.dart';
import 'channel_methods_sender.dart';
import 'channel_methods_receiver.dart';
import 'story_app.dart';

final logger = Logger('Start');

void startStorybook(String packageName, Map<String, StoriesData> storybookDataMap) {
  _setUpLog();
  _setUpFlutterErrors();

  final storybookData = StorybookData(packageName, storybookDataMap);
  runApp(StoryApp(storybookData: storybookData));

  receiveChannelMethodCalls();
  _sendInitialChannelMethodCalls(storybookData);
}

/// In release mode, the defaultLogLevel should be CONFIG.
/// Use log.fine and log.finest for troubleshooting or diagnostics.
void _setUpLog() {
  defaultLogLevel = LogLevel.ALL;
  logToConsole(printTimestamp: true, printLoggerName: true);
  logEnvironmentInformation(logger, LogLevel.FINE);
  logCurrentProcessInformation(logger, LogLevel.FINE);
}

void _setUpFlutterErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  };
}

void _sendInitialChannelMethodCalls(StorybookData storybookData) async {
  await channelMethodsSender.sendPing();
  await channelMethodsSender.sendDeviceDefinitions(DeviceDefinitions());
  await channelMethodsSender.sendStorybookData(storybookData);
  await channelMethodsSender.sendReadySignal();
}