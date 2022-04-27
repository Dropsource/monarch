import 'package:flutter/material.dart';
import '../stockholm/stockholm.dart';

class StockholmThemeData {
  static ThemeData light({StockholmColor? accentColor}) {
    var theme = ThemeData.light();
    var colors = StockholmColors.fromBrightness(Brightness.light);
    accentColor ??= colors.blue;

    theme = _applySharedChanges(theme);

    return theme.copyWith(
      // primaryColorBrightness: Brightness.light,
      // primarySwatch: Colors.blue,
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.blueGrey[50],
      primaryColor: accentColor,
      indicatorColor: accentColor,
      highlightColor: Colors.black26,
      disabledColor: Colors.black26,
      colorScheme: theme.colorScheme.copyWith(
        primary: accentColor,
        secondary: accentColor.contrast,
      ),
      popupMenuTheme: theme.popupMenuTheme.copyWith(
        textStyle: theme.textTheme.bodyText2,
        color: Colors.grey.shade100,
      ),
      dialogTheme: theme.dialogTheme.copyWith(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: Colors.black12, width: 1.0),
          )),
      textTheme: theme.textTheme.copyWith(
        caption: theme.textTheme.caption!.copyWith(color: Colors.black38),
      ),
      iconTheme: theme.iconTheme.copyWith(
        color: Colors.grey[700],
      ),
    );
  }

  static ThemeData dark({StockholmColor? accentColor}) {
    var theme = ThemeData.dark();
    var colors = StockholmColors.fromBrightness(Brightness.dark);
    accentColor ??= colors.blue;

    theme = _applySharedChanges(theme);

    return theme.copyWith(
      primaryColor: accentColor,
      popupMenuTheme: theme.popupMenuTheme.copyWith(
        textStyle: theme.textTheme.bodyText2,
        color: Colors.grey.shade900,
      ),
      colorScheme: theme.colorScheme.copyWith(
        primary: accentColor,
        secondary: accentColor.contrast,
      ),
      indicatorColor: accentColor,
      scaffoldBackgroundColor: Colors.grey[900],
      backgroundColor: const Color.fromRGBO(44, 44, 44, 1.0),
      canvasColor: const Color.fromRGBO(38, 38, 38, 1.0),
      hoverColor: Colors.white12,
      cardColor: Colors.grey[900],
      dividerColor: Colors.white24,
      selectedRowColor: Colors.white12,
      dialogTheme: theme.dialogTheme.copyWith(
        backgroundColor: const Color.fromRGBO(44, 44, 44, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Colors.grey[700]!, width: 1.0),
        ),
      ),
    );
  }

  static ThemeData _applySharedChanges(ThemeData theme) {
    return theme.copyWith(
      visualDensity: VisualDensity.compact,
      textTheme: theme.textTheme.copyWith(
        bodyText1: theme.textTheme.bodyText1!.copyWith(fontSize: 13.0),
        bodyText2: theme.textTheme.bodyText2!.copyWith(fontSize: 12.0),
        subtitle1: theme.textTheme.bodyText1!
            .copyWith(fontSize: 13.0, fontWeight: FontWeight.bold),
        subtitle2: theme.textTheme.bodyText2!
            .copyWith(fontSize: 12.0, fontWeight: FontWeight.bold),
        caption: theme.textTheme.caption!
            .copyWith(fontSize: 10.5, fontWeight: FontWeight.bold),
        button: theme.textTheme.button!.copyWith(fontSize: 14.0),
      ),
      splashColor: Colors.transparent,
    );
  }
}
