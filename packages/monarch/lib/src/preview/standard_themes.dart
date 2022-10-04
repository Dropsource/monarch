import 'package:flutter/material.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'monarch_data.dart';

const light = materialLightThemeDefinition;
const dark = materialDarkThemeDefinition;

final standardMetaThemes = [
  MetaTheme(light.id, light.name, ThemeData.light(), light.isDefault),
  MetaTheme(dark.id, dark.name, ThemeData.dark(), dark.isDefault)
];
