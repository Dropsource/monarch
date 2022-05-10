
import 'package:monarch_controller/data/visual_debug_flags.dart';

import 'dock_definition.dart';
import 'monarch_data.dart';

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
  VisualDebugFlag(
    name: Flags.slowAnimations,
    label: 'dev_tools.slow_animations',
  ),
  VisualDebugFlag(
    name: Flags.highlightRepaints,
    label: 'dev_tools.highlight_repaints',
  ),
  VisualDebugFlag(
    label: 'dev_tools.show_guideliness',
    name: Flags.showGuidelines,
  ),
  VisualDebugFlag(
    name: Flags.highlightOversizedImages,
    label: 'dev_tools.highlight_oversized_images',
  ),
  VisualDebugFlag(
    label: 'dev_tools.show_baseliness',
    name: Flags.showBaselines,
  ),
];
