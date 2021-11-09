import 'dart:ui';

import 'active_value.dart';

class ActiveLocale extends ActiveValue<Locale?> {
  Locale? _activeLocale;

  @override
  Locale? get value => _activeLocale;

  void setActiveLocaleTag(String localeTag) {
    if (localeTag == 'System Locale') {
      // As of 2020-10-08, the Monarch platform apps send 'System Locale' when there aren't
      // any user-defined locales, in which case the StoryApp will create a MaterialApp
      // without any localization data. In this case, Flutter's default behavior is to
      // use the only supported locale which is en-US.
      value = null;
    } else {
      value = parseLocale(localeTag);
    }
  }

  @override
  void setValue(Locale? newValue) {
    _activeLocale = newValue;
  }

  @override
  String get valueSetMessage =>
      value == null ? 'active locale reset' : 'active locale set: ${value!}';
}

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

final ActiveLocale activeLocale = ActiveLocale();
