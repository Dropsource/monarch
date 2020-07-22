/// Class for the `@MonarchTheme` annotation.
class MonarchTheme {
  
  /// The name of the theme. Monarch will use this name on the UI.
  final String name;

  /// Whether this theme is the default theme for all stories.
  final bool isDefault;

  /// Marks a variable as a theme that Monarch should use.
  /// The variable should be of type `ThemeData` and it should be a top-level
  /// library variable (i.e. not a local variable or class field).
  ///
  /// Example:
  /// ```
  /// @MonarchTheme('My Theme', isDefault: true)
  /// final myTheme = ThemeData(...);
  /// ```
  const MonarchTheme(this.name, {this.isDefault = false})
      : assert(name != null);
}

/// Class for the `@MonarchLocalizations` annotation.
class MonarchLocalizations {

  /// A list of locales the annotated localizations delegate supports.
  final List<MonarchLocale> locales;

  /// Marks a variable as a localizations delegate that Monarch should use.
  /// 
  /// The variable's type should be a class that extends `LocalizationsDelegate<T>`.
  /// The variable should also be a top-level library variable (i.e. not a local
  /// variable or class field).
  /// 
  /// Example, given this class declaration:
  /// ```
  /// class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {...}
  /// ```
  /// Then, we can annotate a variable of that class with the `@MonarchLocalizations`
  /// annotation:
  /// ```
  /// @MonarchLocalizations([MonarchLocale('en', 'US'), MonarchLocale('es')])
  /// const myLocalizationsDelegate = MyLocalizationsDelegate();
  /// ```
  const MonarchLocalizations(this.locales) : assert(locales != null);
}

/// Represents a dart.ui.Locale. Used by [MonarchLocalizations] annotation.
class MonarchLocale {
  final String languageCode;
  final String countryCode;

  /// Creates a new MonarchLocale. The first parameter is the primary language 
  /// subtag. The second parameter is optional and it is the region or country 
  /// subtag.
  const MonarchLocale(this.languageCode, [this.countryCode])
      : assert(languageCode != null),
        assert(languageCode != '');
}

