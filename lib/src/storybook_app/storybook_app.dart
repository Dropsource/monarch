import 'package:flutter/material.dart';

import 'color_palette.dart';
import '../storybook_data.dart';
import 'home.dart';

class StorybookApp extends StatelessWidget {
  final String packageName;
  final StorybookData storybookData;

  StorybookApp({this.packageName, this.storybookData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Storybook Application',
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: Scaffold(
            backgroundColor: ColorPalette.passiveGrey,
            appBar: PreferredSize(
                child: Container(), preferredSize: Size.fromHeight(0)),
            body: StorybookHome(
                packageName: packageName, storybookData: storybookData)));
  }
}
