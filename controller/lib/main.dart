import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monarch_controller/data/channel_methods_sender.dart';

import 'package:monarch_utils/log_config.dart';

import 'package:monarch_controller/utils/localization.dart';
import 'package:monarch_controller/default_theme.dart' as theme;
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/screens/controller_screen.dart';
import 'package:monarch_controller/data/channel_methods_receiver.dart';

const controlsWidth = 250.0;
final manager = ControllerManager(channelMethodsSender: channelMethodsSender);

void main() async {
  _setUpLog();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MonarchControllerApp());
  receiveChannelMethodCalls();
}

void _setUpLog() {
  // ignore: avoid_print
  writeLogEntryStream((String line) => print('controller: $line'),
      printTimestamp: false, printLoggerName: true);
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
