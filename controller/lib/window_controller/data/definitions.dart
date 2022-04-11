import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/dock_definition.dart';

import 'dev_tools_option.dart';

const defaultLocale = Locale('en', 'US');

final defaultDock = DockDefinition(name: 'Dock to left', id: 'left');
final dockList = [
  defaultDock,
  DockDefinition(name: 'Dock to right', id: 'right'),
  DockDefinition(name: 'Undock', id: 'undock'),
];

final devToolsOptions = [
  DevToolsOption(
    label: 'Slow Animations',
    feature: DevToolFeature.slowAnimations,
  ),
  DevToolsOption(
    label: 'Highlight Repaints',
    feature: DevToolFeature.highlightRepaints,
  ),
  DevToolsOption(
    label: 'Show Guideliness',
    feature: DevToolFeature.showGuidelines,
  ),
  DevToolsOption(
    label: 'Highlight Oversized Images',
    feature: DevToolFeature.highlightOversizedImages,
  ),
  DevToolsOption(
    label: 'Show Baseliness',
    feature: DevToolFeature.showBaselines,
  ),
];
