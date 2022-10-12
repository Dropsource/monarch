import 'dart:io';
import 'package:grpc/grpc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monarch_controller/data/preview_notifications_api_service.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import 'package:monarch_utils/log_config.dart';

import 'package:monarch_controller/utils/localization.dart';
import 'package:monarch_controller/default_theme.dart' as theme;
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/screens/controller_screen.dart';

import 'data/preview_api_client.dart';

final _logger = Logger('ControllerMain');

final manager = ControllerManager();

void main(List<String> arguments) async {
  _setUpLog();
  if (arguments.length < 2) {
    _logger.severe(
        'Expected 2 arguments in this order: default-log-level cli-grpc-server-port');
    exit(1);
  }

  defaultLogLevel = LogLevel.fromString(arguments[0], LogLevel.ALL);
  var cliGrpcServerPort = int.tryParse(arguments[1]);

  if (cliGrpcServerPort == null) {
    _logger.severe(
        'Could not parse argument for cli-grpc-server-port to an integer');
    exit(1);
  }

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MonarchControllerApp());
  setUpChannels(cliGrpcServerPort);
}

void _setUpLog() {
  // ignore: avoid_print
  writeLogEntryStream((String line) => print('controller: $line'),
      printTimestamp: false, printLoggerName: true);
  logCurrentProcessInformation(_logger, LogLevel.FINE);
}

void setUpChannels(int cliServerPort) async {
  _logger.info(
      'Will use cli grpc server (discovery service) at port $cliServerPort');
  var channel = constructClientChannel(cliServerPort);
  var discoveryClient = MonarchDiscoveryApiClient(channel);

  var server = Server([PreviewNotificationsApiService(manager)]);
  await server.serve(port: 0);
  var previewNotificationsApiPort = server.port!;
  _logger.info(
      'preview_notifications_api grpc server (preview notifications api service) started on port $previewNotificationsApiPort');
  discoveryClient.registerPreviewNotificationsApi(
      ServerInfo(port: previewNotificationsApiPort));

  var previewApiClient = await getPreviewApiClient(discoveryClient);
  if (previewApiClient == null) {
    _logger.severe('Controller could not find Monarch Preview API');
    exit(1);
  }
  manager.setUpPreviewApi(previewApiClient);
  await manager.loadInitialData();
}

class MonarchControllerApp extends StatelessWidget {
  const MonarchControllerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Monarch Controller',
        theme: theme.theme,
        debugShowCheckedModeBanner: false,
        home: ControllerScreen(manager: manager),
        localizationsDelegates: [
          localizationDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: localizationDelegate.supportedLocales);
  }
}
