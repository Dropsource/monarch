import 'dart:async';

import 'package:stack_trace/stack_trace.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'project_data_manager.dart';
import 'ready_signal.dart';
import 'channel_methods_sender.dart';
import 'channel_methods_receiver.dart';
import 'stories_errors.dart';
import 'monarch_preview.dart';
import 'project_data.dart';
import 'vm_service_client.dart';
import 'monarch_binding.dart';

final _logger = Logger('Start');
StreamSubscription? _willReassembleSubcription;
StreamSubscription? _serverUriSubscription;

void startMonarchPreview(ProjectData Function() getProjectData) {
  Chain.capture(() {
    _startMonarchPreview(getProjectData);
  }, onError: handleUncaughtError);
}

void _startMonarchPreview(ProjectData Function() getProjectData) async {
  final monarchBinding = MonarchBinding.ensureInitialized();

  _setUpLog();
  readySignal.loading();
  projectDataManager.load(getProjectData);
  handleFlutterFrameworkErrors();

  _willReassembleSubcription =
      monarchBinding.willReassembleStream.listen((event) async {
    projectDataManager.load(getProjectData);
    await projectDataManager.sendChannelMethods();
  });

  Timer.run(() {
    monarchBinding
        .attachRootWidget(monarchBinding.wrapWithDefaultView(MonarchPreview()));
  });
  monarchBinding.scheduleWarmUpFrame();

  receiveChannelMethodCalls();
  await _previewApiReady();
  await _connectToVmService();
  await projectDataManager.sendChannelMethods();
  await channelMethodsSender.sendReadySignal();
}

void _setUpLog() {
  writeLogEntryStream((String line) => print('preview: $line'),
      printTimestamp: false, printLoggerName: true);
  logCurrentProcessInformation(_logger, LogLevel.FINE);
}

Future<void> _previewApiReady() async {
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
      _logger.fine('Reached preview_api after $i attempts.');
      return;
    }
    await Future.delayed(Duration(milliseconds: 50));
  }
  _logger.warning('Could not reach preview_api after $maxRetries attempts.');
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

Future dispose() async {
  await _willReassembleSubcription?.cancel();
  await _serverUriSubscription?.cancel();
  await vmServiceClient.disconnect();
}
