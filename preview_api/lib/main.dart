import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import 'package:monarch_utils/log_config.dart';
import 'package:preview_api/src/monarch_yaml_reader.dart';

import 'src/channel_methods_receiver.dart';
import 'src/channel_methods_sender.dart';
import 'src/preview_api_service.dart';
import 'src/preview_notifications.dart';
import 'src/project_data.dart';
import 'src/selections_state.dart';

final _logger = Logger('PreviewApiMain');

final projectDataManager = ProjectDataManager();
final selectionsStateManager = SelectionsStateManager();

void main(List<String> arguments) async {
  _setUpLog();
  if (arguments.length < 3) {
    _logger.severe(
        'Expected 3 arguments in this order: default-log-level discovery-server-port project-directory-path');
    exit(1);
  }

  defaultLogLevel = LogLevel.fromString(arguments[0], LogLevel.ALL);
  var discoveryServerPort = int.tryParse(arguments[1]);

  if (discoveryServerPort == null) {
    _logger.severe(
        'Could not parse argument for discovery-server-port to an integer');
    exit(1);
  }

  final projectDirectoryPath = arguments[2];

  WidgetsFlutterBinding.ensureInitialized();
  setUpChannels(discoveryServerPort, projectDirectoryPath);
}

void _setUpLog() {
  // ignore: avoid_print
  writeLogEntryStream((String line) => print('preview_api: $line'),
      printTimestamp: false, printLoggerName: true);
  logCurrentProcessInformation(_logger, LogLevel.FINE);
}

void setUpChannels(int discoveryServerPort, String projectDirectoryPath) async {
  _logger.info('Will use discovery server at port $discoveryServerPort');
  _logger.info('Will use project directory path: $projectDirectoryPath');

  var channel = constructClientChannel(discoveryServerPort);
  var discoveryClient = MonarchDiscoveryApiClient(channel);

  var previewNotifications = PreviewNotifications(discoveryClient);
  var channelMethodsSender = ChannelMethodsSender();

  var monarchYamlReader = MonarchYamlReader(projectDirectoryPath);
  await monarchYamlReader.read();

  var server = createServer([
    PreviewApiService(projectDataManager, selectionsStateManager,
        previewNotifications, channelMethodsSender, monarchYamlReader)
  ]);
  await server.serve(port: 0);
  var previewApiPort = server.port!;
  _logger.info(
      'preview_api grpc server (preview api service) started on port $previewApiPort');
  await discoveryClient.registerPreviewApi(ServerInfo(port: previewApiPort));

  var channelMethodsReceiver = ChannelMethodsReceiver(projectDataManager,
      selectionsStateManager, previewNotifications, channelMethodsSender);
  channelMethodsReceiver.setUp();
}

Server createServer(List<Service> services) =>
    Server.create(services: services);
