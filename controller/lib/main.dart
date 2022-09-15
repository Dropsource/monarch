import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monarch_controller/data/channel_methods_sender.dart';
import 'package:monarch_utils/log.dart';

import 'package:monarch_utils/log_config.dart';

import 'package:monarch_controller/utils/localization.dart';
import 'package:monarch_controller/default_theme.dart' as theme;
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/screens/controller_screen.dart';
import 'package:monarch_controller/data/channel_methods_receiver.dart';
import 'data/grpc.dart';

final manager = ControllerManager(channelMethodsSender: channelMethodsSender);

final _logger = Logger('ControllerMain');

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
  setUpGrpc(cliGrpcServerPort);
  receiveChannelMethodCalls();
}

void _setUpLog() {
  // ignore: avoid_print
  writeLogEntryStream((String line) => print('controller: $line'),
      printTimestamp: false, printLoggerName: true);
  logCurrentProcessInformation(_logger, LogLevel.FINE);
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
