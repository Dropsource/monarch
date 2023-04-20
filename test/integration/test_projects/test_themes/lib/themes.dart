import 'package:flutter/material.dart';
import 'package:monarch_annotations/monarch_annotations.dart';

/*
Does not generate warning.
*/
@MonarchTheme('Theme Getter - Dark')
ThemeData get getterTheme => ThemeData.dark();

/*
[WARNING] monarch:meta_themes_builder on lib/themes.dart:
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
`@MonarchTheme` annotation on element `functionTheme` will not be used. The `@MonarchTheme` 
annotation should be placed on a top-level (or library) getter.

Proposed change:
```
@MonarchTheme(...)
ThemeData get functionTheme => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/themes
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchTheme('Theme Function - Light')
ThemeData functionTheme() => ThemeData.light();

/*
[WARNING] monarch:meta_themes_builder on lib/themes.dart:
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Consider changing top-level variable `varTheme` to a getter. Hot reloading works better with 
top-level getters. 

Proposed change:
```
@MonarchTheme(...)
ThemeData get varTheme => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/themes
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchTheme('Theme Variable - Dark')
var varTheme = ThemeData.dark();


/*
[WARNING] monarch:meta_themes_builder on lib/themes.dart:
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Consider changing top-level variable `finalTheme` to a getter. Hot reloading works better with 
top-level getters. 

Proposed change:
```
@MonarchTheme(...)
ThemeData get finalTheme => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/themes
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchTheme('Theme Final Variable - Light')
final finalTheme = ThemeData.light();


/*
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Theme `Bad Theme` is not of type `ThemeData`. It will be ignored.
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchTheme('Bad Theme')
NotTheme get badTheme => NotTheme();

class NotTheme {}
