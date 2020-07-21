/// Class for the `@MonarchTheme` annotation.
class MonarchTheme {
  /// The name of the theme. Monarch will use this name on the UI.
  final String name;

  /// Whether this theme is the default theme for all stories.
  final bool isDefault;

  /// Marks a variable as a theme that Monarch should use.
  /// The variable should be of type `ThemeData` and it should be a top-level
  /// library variable (i.e. not a local or class variable).
  ///
  /// Example:
  /// ```
  /// @MonarchTheme('My Theme', isDefault: true)
  /// final myTheme = ThemeData(...);
  /// ```
  const MonarchTheme(this.name, {this.isDefault = false})
      : assert(name != null);
}

class MonarchLocalizations {
  final List<MonarchLocale> locales;

  const MonarchLocalizations(this.locales) : assert(locales != null);
}

class MonarchLocale {
  final String languageCode;
  final String countryCode;

  const MonarchLocale(this.languageCode, [this.countryCode])
      : assert(languageCode != null),
        assert(languageCode != '');
}

// class Story {
//   final String name;
//   final String theme;

//   const Story({this.name, this.theme});
// }
