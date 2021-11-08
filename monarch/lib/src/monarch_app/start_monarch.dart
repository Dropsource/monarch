import 'dart:async';

import 'package:stack_trace/stack_trace.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'monarch_data_instance.dart';
import 'ready_signal.dart';
import 'device_definitions.dart';
import 'story_scale_definitions.dart';
import 'locale_validator.dart';
import 'active_locale.dart';
import 'active_theme.dart';
import 'channel_methods_sender.dart';
import 'channel_methods_receiver.dart';
import 'reassemble_listener.dart';
import 'standard_themes.dart';
import 'stories_errors.dart';
import 'story_app.dart';
import 'monarch_data.dart';
import 'vm_service_client.dart';
import 'monarch_binding.dart';

final _logger = Logger('Start');

void startMonarch(MonarchData Function() getMonarchData) {
  Chain.capture(() {
    _startMonarch(getMonarchData);
  }, onError: handleUncaughtError);
}

void _startMonarch(MonarchData Function() getMonarchData) async {
  final monarchBinding = MonarchBinding.ensureInitialized() as MonarchBinding;

  _setUpLog();

  readySignal.starting();
  _logger.finest('Starting Monarch flutter app');

  loadMonarchDataInstance(getMonarchData);

  handleFlutterFrameworkErrors();
  _setMetaThemesAndLocalizations();

  monarchBinding.attachRootWidget(ReassembleListener(
      onReassemble: () {
        loadMonarchDataInstance(getMonarchData);
        _setMetaThemesAndLocalizations();
        channelMethodsSender.sendMonarchData(monarchDataInstance);
      },
      child: MonarchStoryApp()));
  monarchBinding.scheduleFrame();

  receiveChannelMethodCalls();
  await _connectToVmService();
  _sendInitialChannelMethodCalls();
}

void _setMetaThemesAndLocalizations() {
  activeTheme.setMetaThemes(
      [...monarchDataInstance.metaThemes, ...standardMetaThemes]);
  activeLocale.localeValidator = 
      LocaleValidator(monarchDataInstance.metaLocalizations);
  // for (var item in monarchDataInstance.metaLocalizations) {
  //   _logger.shout(item.locales.join(','));
  // }
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
  writeLogEntryStream(print, printTimestamp: false, printLoggerName: true);
}

void _sendInitialChannelMethodCalls() async {
  await channelMethodsSender.sendPing();
  await channelMethodsSender.sendDefaultTheme(activeTheme.defaultMetaTheme.id);
  await channelMethodsSender.sendDeviceDefinitions(DeviceDefinitions());
  await channelMethodsSender.sendStoryScaleDefinitions(StoryScaleDefinitions());
  await channelMethodsSender.sendStandardThemes(StandardThemes());
  await channelMethodsSender.sendMonarchData(monarchDataInstance);
  await channelMethodsSender.sendReadySignal();
}
