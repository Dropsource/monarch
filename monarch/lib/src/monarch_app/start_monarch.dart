import 'package:flutter/material.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'active_theme.dart';
import 'channel_methods_sender.dart';
import 'channel_methods_receiver.dart';
import 'standard_themes.dart';
import 'stories_errors.dart';
import 'story_app.dart';
import 'monarch_data.dart';
import 'user_message.dart';

final logger = Logger('Start');

void startMonarch(String packageName, List<MetaTheme> userMetaThemes,
    Map<String, MetaStories> metaStoriesMap) {
  _setUpLog();

  logger.finest('Starting storybook flutter app');

  userMetaThemes = _validateAndFilterMetaThemes(userMetaThemes);

  final storybookData =
      MonarchData(packageName, userMetaThemes, metaStoriesMap);

  setUpStoriesErrors(storybookData);
  activeTheme.setMetaThemes([...userMetaThemes, ...standardMetaThemes]);

  runApp(StoryApp(storybookData: storybookData));

  receiveChannelMethodCalls();
  _sendInitialChannelMethodCalls(storybookData);
}

void _setUpLog() {
  defaultLogLevel = LogLevel.ALL;
  logToConsole(printTimestamp: false, printLoggerName: true);
}

List<MetaTheme> _validateAndFilterMetaThemes(List<MetaTheme> metaThemeList) {
  final _list = <MetaTheme>[];
  for (var item in metaThemeList) {
    if (item.theme == null) {
      printUserMessage('Theme "${item.name}" is not of type ThemeData. It will be ignored.');
    }
    else {
      logger.fine('Valid theme found: ${item.name}');
      _list.add(item);
    }
  }
  return _list;
}

void _sendInitialChannelMethodCalls(MonarchData storybookData) async {
  await channelMethodsSender.sendPing();
  await channelMethodsSender.sendDefaultTheme(activeTheme.defaultMetaTheme.id);
  await channelMethodsSender.sendStorybookData(storybookData);
  await channelMethodsSender.sendReadySignal();
}
