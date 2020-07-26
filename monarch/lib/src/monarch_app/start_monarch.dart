import 'package:flutter/material.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'localizations_delegate_loader.dart';
import 'active_locale.dart';
import 'active_theme.dart';
import 'channel_methods_sender.dart';
import 'channel_methods_receiver.dart';
import 'standard_themes.dart';
import 'stories_errors.dart';
import 'story_app.dart';
import 'monarch_data.dart';
import 'user_message.dart';

final logger = Logger('Start');

void startMonarch(
    String packageName,
    List<MetaLocalization> userMetaLocalizations,
    List<MetaTheme> userMetaThemes,
    Map<String, MetaStories> metaStoriesMap) async {
  _setUpLog();

  logger.finest('Starting Monarch flutter app');

  userMetaLocalizations =
      _validateAndFilterMetaLocalizations(userMetaLocalizations);
  userMetaThemes = _validateAndFilterMetaThemes(userMetaThemes);

  final monarchData = MonarchData(
      packageName, userMetaLocalizations, userMetaThemes, metaStoriesMap);

  setUpStoriesErrors(monarchData);
  activeTheme.setMetaThemes([...userMetaThemes, ...standardMetaThemes]);
  activeLocale = ActiveLocale(LocalizationsDelegateLoader(monarchData.metaLocalizations));
  if (monarchData.metaLocalizations.isNotEmpty) {
    activeLocale.setActiveLocale(monarchData.allLocales.first);
  }

  runApp(StoryApp(
    monarchData: monarchData,
  ));

  receiveChannelMethodCalls();
  _sendInitialChannelMethodCalls(monarchData);
}

void _setUpLog() {
  defaultLogLevel = LogLevel.ALL;
  logToConsole(printTimestamp: false, printLoggerName: true);
}

List<MetaLocalization> _validateAndFilterMetaLocalizations(
    List<MetaLocalization> metaLocalizationList) {
  final _list = <MetaLocalization>[];
  for (var item in metaLocalizationList) {
    if (item.delegate == null) {
      printUserMessage(
          '${item.delegateClassName} doesn\'t extend LocalizationsDelegate<T>. '
          'It will be ignored.');
    } else if (item.locales.isEmpty) {
      printUserMessage(
          '@MonarchLocalizations annotation on ${item.delegateClassName} '
          'doesn\'t declare any locales. It will be ignored.');
    } else {
      logger.fine(
          'Valid localization found on class ${item.delegateClassName} with '
          'annotated locales: ${item.locales.map((e) => e.languageCode).toList()}');
      _list.add(item);
    }
  }
  return _list;
}

List<MetaTheme> _validateAndFilterMetaThemes(List<MetaTheme> metaThemeList) {
  final _list = <MetaTheme>[];
  for (var item in metaThemeList) {
    if (item.theme == null) {
      printUserMessage(
          'Theme "${item.name}" is not of type ThemeData. It will be ignored.');
    } else {
      logger.fine('Valid theme found: ${item.name}');
      _list.add(item);
    }
  }
  return _list;
}

void _sendInitialChannelMethodCalls(MonarchData monarchData) async {
  await channelMethodsSender.sendPing();
  await channelMethodsSender.sendDefaultTheme(activeTheme.defaultMetaTheme.id);
  await channelMethodsSender.sendMonarchData(monarchData);
  await channelMethodsSender.sendReadySignal();
}
