import 'package:monarch_window_controller/window_controller/data/dock_definition.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';

import 'dev_tools_option.dart';

const defaultTheme = MetaTheme(
    id: '__material-light-theme__',
    name: 'Material Light Theme',
    isDefault: true);

const defaultLocale = 'System Locale';

final defaultDock = DockDefinition(name: 'dock_settings.left', id: 'left');
final dockList = [
  defaultDock,
  DockDefinition(name: 'dock_settings.right', id: 'right'),
  DockDefinition(name: 'dock_settings.undock', id: 'undock'),
];

final devToolsOptions = [
  DevToolsOption(
    label: 'dev_tools.slow_animations',
    feature: DevToolFeature.slowAnimations,
  ),
  DevToolsOption(
    label: 'dev_tools.highlight_repaints',
    feature: DevToolFeature.highlightRepaints,
  ),
  DevToolsOption(
    label: 'dev_tools.show_guideliness',
    feature: DevToolFeature.showGuidelines,
  ),
  DevToolsOption(
    label: 'dev_tools.highlight_oversized_images',
    feature: DevToolFeature.highlightOversizedImages,
  ),
  DevToolsOption(
    label: 'dev_tools.show_baseliness',
    feature: DevToolFeature.showBaselines,
  ),
];
