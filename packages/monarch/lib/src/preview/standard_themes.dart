import 'package:flutter/material.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'project_data.dart';

const _light = materialLightThemeDefinition;
const _dark = materialDarkThemeDefinition;
const _light3 = material3LightThemeDefinition;
const _dark3 = material3DarkThemeDefinition;

final lightTheme = MetaTheme(_light.id, _light.name,
    ThemeData.light(useMaterial3: false), _light.isDefault);

final darkTheme = MetaTheme(
    _dark.id, _dark.name, ThemeData.dark(useMaterial3: false), _dark.isDefault);

final light3Theme = MetaTheme(_light3.id, _light3.name,
    ThemeData.light(useMaterial3: true), _light3.isDefault);

final dartk3Theme = MetaTheme(_dark3.id, _dark3.name,
    ThemeData.dark(useMaterial3: true), _dark3.isDefault);

final defaultTheme = lightTheme;

final standardMetaThemes = [lightTheme, darkTheme, light3Theme, dartk3Theme];
