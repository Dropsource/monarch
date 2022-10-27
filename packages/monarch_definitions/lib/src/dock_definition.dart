class DockDefinition {
  final String name;
  final String id;

  DockDefinition({
    required this.name,
    required this.id,
  });
}

final defaultDockDefinition =
    DockDefinition(name: 'dock_settings.right', id: 'right');

final dockDefinitions = [
  defaultDockDefinition,
  DockDefinition(name: 'dock_settings.left', id: 'left'),
  DockDefinition(name: 'dock_settings.undock', id: 'undock'),
];
