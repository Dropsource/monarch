import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;

class Translations {
  Locale locale;

  static Map<String, dynamic> _localizedValues = <String, dynamic>{};

  static Translations? of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  Translations(this.locale);

  /// Used to translate a [key] in the current dictionary.
  String text(String key) {
    return _localizedValues[key] ?? '_$key';
  }

  /// Returns the text in the correct grammatical number.
  /// This method uses textWithArgs so remember to add arguments in the [singular] and [plural] params.
  String textWithCardinality(int length, String singular, String plural) {
    return textWithArgs(
      length == 1 ? singular : plural,
      [length.toString()],
    );
  }

  /// Used to translate a [key] but also to interpolate some arguments in the translation.
  ///
  /// Translation will have a set of markets identified by '$$s' which will then be replaced by the arguments.
  /// i.e.
  /// 'Welcome $$s, I see you are feeling $$s' with [textWithArgs('welcome', ['David', 'sad')]
  /// would return 'Welcome David, I see you are feeling sad'
  ///
  /// Please note that the arguments will NOT be localized and will replace the markers as they are passed.
  String textWithArgs(String? key, List<String> args) {
    String? text = _localizedValues[key];
    if (text == null) {
      return '_$key';
    }
    var marker = '\$\$s';
    int markerIndex = 0;
    for (var arg in args) {
      markerIndex = text!.indexOf(marker);
      if (markerIndex != -1) {
        text = text.replaceFirst(marker, arg, markerIndex);
      }
    }
    return text!;
  }

  static Future<Translations> load(
    Locale locale,
    TranslationsBundleLoader loader,
  ) async {
    Translations translations = Translations(locale);
    _localizedValues = await loader.loadTranslationsDictionary(locale);
    return translations;
  }

  String get currentLanguage => locale.languageCode;
}

/// Consider creating an abstract class TranslationsLoader for each implementation.
///
/// This loader gets the translations from the app bundle, but we could use firebase or any other.
abstract class TranslationsBundleLoader {
  TranslationsBundleLoader();

  Future<Map<String, dynamic>> loadTranslationsDictionary(Locale locale);
}

class FileTranslationsBundleLoader extends TranslationsBundleLoader {
  final String path;
  final AssetBundle? bundle; // Defaults to rootBundle if none provided
  FileTranslationsBundleLoader(this.path, {this.bundle}) : super();

  @override
  Future<Map<String, dynamic>> loadTranslationsDictionary(Locale locale) async {
    // var bundle = DefaultAssetBundle.of(context);
    String jsonContent = await (bundle ?? rootBundle)
        .loadString('$path/i18n_${locale.languageCode}.json');
    return json.decode(jsonContent);
  }
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  final TranslationsBundleLoader bundleLoader;
  final Locale? defaultLocale;
  final List<Locale> supportedLocales;

  const TranslationsDelegate(
    this.bundleLoader, {
    this.supportedLocales = const [
      Locale('en', 'US'),
    ],
    this.defaultLocale,
  });

  List<String> get supportedLanguages =>
      supportedLocales.map((l) => l.languageCode).toList();

  @override
  bool isSupported(Locale locale) =>
      supportedLanguages.contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) =>
      Translations.load(locale, bundleLoader);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
