import 'package:flutter/material.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'monarch_data.dart';

const _light = materialLightThemeDefinition;
const _dark = materialDarkThemeDefinition;

final lightTheme =
    MetaTheme(_light.id, _light.name, ThemeData.light(), _light.isDefault);
final dartkTheme =
    MetaTheme(_dark.id, _dark.name, ThemeData.dark(), _dark.isDefault);

final defaultTheme = lightTheme;

final standardMetaThemes = [lightTheme, dartkTheme];
