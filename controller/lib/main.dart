import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monarch_window_controller/utils/localization.dart';
import 'package:monarch_window_controller/window_controller/default_theme.dart'
    as theme;
import 'package:monarch_window_controller/window_controller/window_controller_screen.dart';
import 'package:window_size/window_size.dart';

const controlsWidth = 250.0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {


    var window = await getWindowInfo();
    if (window.screen != null) {
      final screenFrame = window.screen!.visibleFrame;
      const width = 700.0;
      const height = 850.0;
      final left = ((screenFrame.width - width) / 2).roundToDouble();
      final top = ((screenFrame.height - height) / 3).roundToDouble();

      final frame = Rect.fromLTWH(left, top, width, height);
      setWindowFrame(frame);

      setWindowTitle('Monarch');
      setWindowMinSize(
        const Size(
          700,
          850,
        ),
      );
    }
    //setWindowMaxSize(const Size(505, 800));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Window Controller',
      theme: theme.theme,
      home: const WindowControllerScreen(),
      localizationsDelegates: [
        localizationDelegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: localizationDelegate.supportedLocales
    );
  }
}
