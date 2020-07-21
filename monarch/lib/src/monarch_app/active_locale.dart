import 'dart:async';
import 'dart:ui';

import 'package:monarch_utils/log.dart';

class ActiveLocale with Log {
  String _activeLocale;
  String get activeLocale => _activeLocale ?? defaultLocale;

  final _activeLocaleStreamController = StreamController<String>.broadcast();
  Stream<String> get activeLocaleStream => _activeLocaleStreamController.stream;

  void setActiveLocale(String locale) {
    _activeLocale = locale;
    _activeLocaleStreamController.add(activeLocale);
    log.fine('active locale set: $locale');
  }

  void resetActiveLocale() {
    _activeLocale = defaultLocale;
    _activeLocaleStreamController.add(activeLocale);
  }

  void close() {
    _activeLocaleStreamController.close();
  }
}

const defaultLocale = 'en-US';

Locale parseLocale(String locale) {
  ArgumentError.checkNotNull(locale, 'locale');
  if (locale.isEmpty) {
    throw ArgumentError.value(locale, 'locale', 'Should not be empty');
  }
  final tokens = locale.split('-');
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
      throw ArgumentError('locale cannot be parsed, got $locale');
  }
}

final activeLocale = ActiveLocale();
