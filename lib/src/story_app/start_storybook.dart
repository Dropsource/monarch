import 'package:flutter/material.dart';


import '../device_definitions.dart';
import '../log/dropsource_log.dart';
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

void _setUpLog() {
  defaultLogLevel = LogLevel.CONFIG;
  logToConsole(recordTime: true);
  logEnvironmentInformation(logger);
  logCurrentProcessInformation(logger);
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
}