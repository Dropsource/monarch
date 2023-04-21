import 'package:flutter/widgets.dart'
    show BuildContext, Locale, Localizations, LocalizationsDelegate;
import 'package:monarch_annotations/monarch_annotations.dart';

const english = Locale('en', 'US');
const spanish = Locale('es', 'US');
const french = Locale('fr', 'FR');
const german = Locale('de', 'DE');

/*
Does not generate warning.
*/
@MonarchLocalizations([MonarchLocale('en', 'US')])
const constDelegate = SampleLocalizationsDelegate(
  supportedLocales: [english, german],
  defaultLocale: english,
);

/*
Does not generate warning.
*/
@MonarchLocalizations([MonarchLocale('es', 'US')])
SampleLocalizationsDelegate get getterDelegate =>
    const SampleLocalizationsDelegate(
      supportedLocales: [spanish],
      defaultLocale: spanish,
    );

/*
[WARNING] monarch:meta_localizations_builder on lib/localizations.dart:
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Consider changing top-level variable `varDelegate` to a getter or const. Hot reloading works better 
with top-level getters or const variables. 

Proposed change:
```
@MonarchLocalizations(...)
SampleLocalizationsDelegate get varDelegate => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/internationalization
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchLocalizations([MonarchLocale('fr', 'FR')])
var varDelegate = const SampleLocalizationsDelegate(
  supportedLocales: [french],
  defaultLocale: french,
);

/*
[WARNING] monarch:meta_localizations_builder on lib/localizations.dart:
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
`@MonarchLocalizations` annotation on element `functionDelegate` will not be used. 
The `@MonarchLocalizations` annotation should be placed on a top-level getter or const.
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchLocalizations([MonarchLocale('de', 'DE')])
SampleLocalizationsDelegate functionDelegate() =>
    const SampleLocalizationsDelegate(
      supportedLocales: [german],
      defaultLocale: german,
    );


/*
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
`@MonarchLocalizations` annotation on `emptyDelegate` doesn't declare any locales. It will 
be ignored.
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchLocalizations([])
const emptyDelegate = SampleLocalizationsDelegate(
  supportedLocales: [english],
  defaultLocale: english,
);


/*
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
Type of `badLocalizationsDelegate` doesn't extend `LocalizationsDelegate<T>`. It will be ignored.
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchLocalizations([MonarchLocale('en', 'US'), MonarchLocale('es', 'ES')])
NotLocalizationsDelegate get badLocalizationsDelegate => NotLocalizationsDelegate();

class NotLocalizationsDelegate {}

class SampleLocalizationsDelegate
    extends LocalizationsDelegate<SampleLocalizations> {
  final Locale defaultLocale;
  final List<Locale> supportedLocales;

  const SampleLocalizationsDelegate({
    this.supportedLocales = const [],
    required this.defaultLocale,
  });

  List<String> get supportedLanguages =>
      supportedLocales.map((l) => l.languageCode).toList();

  @override
  bool isSupported(Locale locale) =>
      supportedLanguages.contains(locale.languageCode);

  @override
  Future<SampleLocalizations> load(Locale locale) =>
      SampleLocalizations.load(locale);

  @override
  bool shouldReload(SampleLocalizationsDelegate old) => false;
}

class SampleLocalizations {
  Locale locale;

  static SampleLocalizations? of(BuildContext context) {
    return Localizations.of<SampleLocalizations>(context, SampleLocalizations);
  }

  SampleLocalizations(this.locale);

  String text(String key) {
    return '($locale) $key';
  }

  static Future<SampleLocalizations> load(
    Locale locale,
  ) async {
    var translations = SampleLocalizations(locale);
    return translations;
  }
}
