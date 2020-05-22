class StorybookTheme {
  final String name;
  final bool isDefault;

  const StorybookTheme(this.name, {this.isDefault = false}) : assert(name != null);
}

class Story {
  final String name;
  final String theme;

  const Story({this.name, this.theme});
}