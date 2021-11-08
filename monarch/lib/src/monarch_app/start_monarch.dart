import 'dart:async';

import 'package:stack_trace/stack_trace.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'monarch_data_instance.dart';
import 'ready_signal.dart';
import 'device_definitions.dart';
import 'story_scale_definitions.dart';
import 'localizations_delegate_loader.dart';
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

void startMonarch(
    MonarchData Function() getMonarchData) {
  Chain.capture(() {
    _startMonarch(
        getMonarchData);
  }, onError: handleUncaughtError);
}

void _startMonarch(
    MonarchData Function() getMonarchData) async {
  final monarchBinding = MonarchBinding.ensureInitialized() as MonarchBinding;

  _setUpLog();

  readySignal.starting();
  _logger.finest('Starting Monarch flutter app');

  loadMonarchDataInstance(getMonarchData);

  handleFlutterFrameworkErrors();
  activeTheme.setMetaThemes([...monarchDataInstance.metaThemes, ...standardMetaThemes]);
  activeLocale =
      ActiveLocale(LocalizationsDelegateLoader(monarchDataInstance.metaLocalizations));

  monarchBinding.attachRootWidget(ReassembleListener(
      onReassemble: () {
        loadMonarchDataInstance(getMonarchData);
        for (var item in monarchDataInstance.metaStoriesMap.values) {
          _logger.shout('story count ${item.storiesNames.length}');
        }
        channelMethodsSender.sendMonarchData(monarchDataInstance);
      },
      child: MonarchStoryApp()));
  monarchBinding.scheduleFrame();

  receiveChannelMethodCalls();
  await _connectToVmService();
  _sendInitialChannelMethodCalls(monarchDataInstance);
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

void _sendInitialChannelMethodCalls(MonarchData monarchData) async {
  await channelMethodsSender.sendPing();
  await channelMethodsSender.sendDefaultTheme(activeTheme.defaultMetaTheme.id);
  await channelMethodsSender.sendDeviceDefinitions(DeviceDefinitions());
  await channelMethodsSender.sendStoryScaleDefinitions(StoryScaleDefinitions());
  await channelMethodsSender.sendStandardThemes(StandardThemes());
  await channelMethodsSender.sendMonarchData(monarchData);
  await channelMethodsSender.sendReadySignal();
}
