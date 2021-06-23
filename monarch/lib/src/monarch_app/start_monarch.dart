import 'package:flutter/material.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'ready_signal.dart';
import 'device_definitions.dart';
import 'story_scale_definitions.dart';
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
import 'vm_service_client.dart';
import 'monarch_binding.dart';

final _logger = Logger('Start');

void startMonarch(
    String packageName,
    List<MetaLocalization> userMetaLocalizations,
    List<MetaTheme> userMetaThemes,
    Map<String, MetaStories> metaStoriesMap) async {
  final monarchBinding = MonarchBinding.ensureInitialized() as MonarchBinding;

  _setUpLog();

  readySignal.starting();
  _logger.finest('Starting Monarch flutter app');

  userMetaLocalizations =
      _validateAndFilterMetaLocalizations(userMetaLocalizations);
  userMetaThemes = _validateAndFilterMetaThemes(userMetaThemes);

  final monarchData = MonarchData(
      packageName, userMetaLocalizations, userMetaThemes, metaStoriesMap);

  setUpStoriesErrors(monarchData);
  activeTheme.setMetaThemes([...userMetaThemes, ...standardMetaThemes]);
  activeLocale =
      ActiveLocale(LocalizationsDelegateLoader(monarchData.metaLocalizations));

  monarchBinding.attachRootWidget(StoryApp(
    monarchData: monarchData,
  ));
  monarchBinding.scheduleFrame();

  receiveChannelMethodCalls();
  await _connectToVmService();
  _sendInitialChannelMethodCalls(monarchData);
}

Future<void> _connectToVmService() async {
  try {
    await vmServiceClient.connect();
  } catch (e, s) {
    _logger.warning(
        'Error while connecting to VM Service. Features like Debug '
        'Paint may not work.',
        e,
        s);
  }
}

void _setUpLog() {
  defaultLogLevel = LogLevel.ALL;
  writeLogEntryStream(print, printTimestamp: false, printLoggerName: true);
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
      _logger.fine(
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
      _logger.fine('Valid theme found: ${item.name}');
      _list.add(item);
    }
  }
  return _list;
}

void _sendInitialChannelMethodCalls(MonarchData monarchData) async {
  await channelMethodsSender.sendPing();
  await channelMethodsSender.sendDefaultTheme(activeTheme.defaultMetaTheme.id);
  await channelMethodsSender.sendDeviceDefinitions(DeviceDefinitions());
  await channelMethodsSender.sendStoryScaleDefinitions(StoryScaleDefinitions());
  await channelMethodsSender.sendStandardThemes(StandardThemes());
  await channelMethodsSender.sendMonarchData(monarchData);
  await channelMethodsSender.sendReadySignal();
}
