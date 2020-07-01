import 'channel_methods.dart';
import 'package:flutter/material.dart';

import 'storybook_data.dart';

final standardMetaThemes = [
  MetaTheme('__material-light-theme__', 'Material Light Theme',
      ThemeData.light(), true),
  MetaTheme(
      '__material-dark-theme__', 'Material Dark Theme', ThemeData.dark(), false)
];

class StandardThemes implements OutboundChannelArgument {
  @override
  Map<String, dynamic> toStandardMap() {
    return {
      'standardThemes': standardMetaThemes.map((d) => d.toStandardMap()).toList(),
    };
  }
}