import 'package:flutter/widgets.dart' show Locale;
import 'package:monarch_annotations/monarch_annotations.dart';
import 'package:monarch_window_controller/utils/tranlsations.dart';

final Locale _english = Locale('en', 'US');
final Locale _spanish = Locale('es', 'ES');

@MonarchLocalizations([MonarchLocale('en', 'US'), MonarchLocale('es', 'ES')])
final TranslationsDelegate localizationDelegate = TranslationsDelegate(
  FileTranslationsBundleLoader('locale'),
  supportedLocales: [_english, _spanish],
  defaultLocale: _english,
);