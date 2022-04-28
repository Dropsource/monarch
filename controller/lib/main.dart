import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'package:monarch_window_controller/utils/localization.dart';
import 'package:monarch_window_controller/window_controller/default_theme.dart'
    as theme;
import 'package:monarch_window_controller/window_controller/window_controller_manager.dart';
import 'package:monarch_window_controller/window_controller/window_controller_screen.dart';
import 'window_controller/data/channel_methods_receiver.dart';
import 'package:stockholm/stockholm.dart';

const controlsWidth = 250.0;
final manager = WindowControllerManager();

void main() async {
  _setUpLog();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  receiveChannelMethodCalls();
}

void _setUpLog() {
  // ignore: avoid_print
  writeLogEntryStream((String line) => print('controller: $line'),
      printTimestamp: false, printLoggerName: true);
}

class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Window Controller',
        theme: theme.theme,
        home:  WindowControllerScreen(manager: manager),
        localizationsDelegates: [
          localizationDelegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: localizationDelegate.supportedLocales);
  }
}
