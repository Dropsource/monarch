import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/default_theme.dart'
    as theme;
import 'package:monarch_window_controller/window_controller/window_controller_screen.dart';
import 'package:window_size/window_size.dart';

const controlsWidth = 250.0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Monarch');
    setWindowMinSize(
      const Size(
        505,
        650,
      ),
    );
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
    );
  }
}
