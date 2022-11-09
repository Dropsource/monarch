import 'package:flutter/widgets.dart' show Locale;
import 'package:monarch_annotations/monarch_annotations.dart';
import 'package:monarch_controller/utils/translations.dart';

const Locale _english = Locale('en', 'US');
const Locale _spanish = Locale('es', 'ES');

@MonarchLocalizations([MonarchLocale('en', 'US'), MonarchLocale('es', 'ES')])
TranslationsDelegate get localizationDelegate => TranslationsDelegate(
      FileTranslationsBundleLoader('locale'),
      supportedLocales: [_english, _spanish],
      defaultLocale: _english,
    );
