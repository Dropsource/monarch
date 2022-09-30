import 'dart:async';

import 'package:stack_trace/stack_trace.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'monarch_data_manager.dart';
import 'ready_signal.dart';
import 'device_definitions.dart';
import 'story_scale_definitions.dart';
import 'active_theme.dart';
import 'channel_methods_sender.dart';
import 'channel_methods_receiver.dart';
import 'standard_themes.dart';
import 'stories_errors.dart';
import 'monarch_preview.dart';
import 'monarch_data.dart';
import 'vm_service_client.dart';
import 'monarch_binding.dart';

final _logger = Logger('Start');
StreamSubscription? _willReassembleSubcription;
StreamSubscription? _serverUriSubscription;

void startMonarchPreview(MonarchData Function() getMonarchData) {
  Chain.capture(() {
    _startMonarchPreview(getMonarchData);
  }, onError: handleUncaughtError);
}

void _startMonarchPreview(MonarchData Function() getMonarchData) async {
  final monarchBinding = MonarchBinding.ensureInitialized();

  _setUpLog();
  readySignal.loading();
  monarchDataManager.load(getMonarchData);
  handleFlutterFrameworkErrors();

  _willReassembleSubcription =
      monarchBinding.willReassembleStream.listen((event) async {
    monarchDataManager.load(getMonarchData);
    await monarchDataManager.sendChannelMethods();
  });

  Timer.run(() {
    monarchBinding.attachRootWidget(MonarchPreview());
  });
  monarchBinding.scheduleWarmUpFrame();

  receiveChannelMethodCalls();
  await _controllerReady();
  await _connectToVmService();
  await _sendDefinitions();
  await monarchDataManager.sendChannelMethods();
  await channelMethodsSender.sendReadySignal();
}

void _setUpLog() {
  writeLogEntryStream((String line) => print('preview: $line'),
      printTimestamp: false, printLoggerName: true);
  logCurrentProcessInformation(_logger, LogLevel.FINE);
}

Future<void> _controllerReady() async {
  const maxRetries = 5;

  Future<bool> canPing() async {
    try {
      final result = await channelMethodsSender.sendPing();
      return result == true;
    } catch (e) {
      return false;
    }
  }

  for (var i = 1; i <= maxRetries; i++) {
    if (await canPing()) {
      _logger.fine('Monarch Preview reached Controller after $i attempts.');
      return;
    }
    await Future.delayed(Duration(milliseconds: 50));
  }
  _logger.warning(
      'Monarch Preview could not reach Controller after $maxRetries attempts.');
}

Future<void> _connectToVmService() async {
  _serverUriSubscription = vmServiceClient.serverUriStream.listen((uri) {
    channelMethodsSender.sendPreviewVmServerUri(uri);
  });
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

Future<void> _sendDefinitions() async {
  await channelMethodsSender.sendDefaultTheme(activeTheme.defaultMetaTheme.id);
  /// @TODO: device definitions and story scale definitions are referenced data, 
  /// the preview server will send them to the controller, the preview won't need them anymore
  await channelMethodsSender.sendDeviceDefinitions(DeviceDefinitions());
  await channelMethodsSender.sendStoryScaleDefinitions(StoryScaleDefinitions());
  await channelMethodsSender.sendStandardThemes(StandardThemes());
}

Future dispose() async {
  await _willReassembleSubcription?.cancel();
  await _serverUriSubscription?.cancel();
  await vmServiceClient.disconnect();
}
