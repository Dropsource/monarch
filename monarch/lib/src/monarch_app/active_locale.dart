import 'dart:async';
import 'dart:ui';

import 'package:monarch_utils/log.dart';

class ActiveLocale with Log {
  Locale _activeLocale;
  Locale get activeLocale => _activeLocale;

  final _activeLocaleStreamController = StreamController<Locale>.broadcast();
  Stream<Locale> get activeLocaleStream => _activeLocaleStreamController.stream;

  void setActiveLocale(Locale locale) {
    _activeLocale = locale;
    _activeLocaleStreamController.add(activeLocale);
    log.fine('active locale set: ${locale.toLanguageTag()}');
  }

  void setActiveLocaleTag(String localeTag) {
    setActiveLocale(parseLocale(localeTag));
  }

  void resetActiveLocale() {
    _activeLocale = null;
    _activeLocaleStreamController.add(activeLocale);
  }

  void close() {
    _activeLocaleStreamController.close();
  }
}

const defaultLocale = Locale('en', 'US');

Locale parseLocale(String localeTag) {
  ArgumentError.checkNotNull(localeTag, 'localeTag');
  if (localeTag.isEmpty) {
    throw ArgumentError.value(localeTag, 'localeTag', 'Should not be empty');
  }
  final tokens = localeTag.split('-');
  switch (tokens.length) {
    case 1:
      return Locale(tokens[0]);

    case 2:
      return Locale(tokens[0], tokens[1]);

    case 3:
      return Locale.fromSubtags(
          languageCode: tokens[0],
          scriptCode: tokens[1],
          countryCode: tokens[2]);

    default:
      throw ArgumentError('locale tag cannot be parsed, got $localeTag');
  }
}

final activeLocale = ActiveLocale();
