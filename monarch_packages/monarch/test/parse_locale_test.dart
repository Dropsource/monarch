import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:monarch/src/monarch_app/active_locale.dart';

void main() {
  group('parseLocale()', () {
    test('happy', () {
      Locale locale;

      locale = parseLocale('en');
      expect(locale, Locale('en'));

      locale = parseLocale('en-US');
      expect(locale, Locale('en', 'US'));

      locale = parseLocale('fr-123-CA');
      expect(
          locale,
          Locale.fromSubtags(
              languageCode: 'fr', scriptCode: '123', countryCode: 'CA'));
    });

    test('errors', () {
      expect(() => parseLocale(''), throwsArgumentError);
      expect(() => parseLocale('a-b-c-d'), throwsArgumentError);
      expect(() => parseLocale('a-b-c-'), throwsArgumentError);
    });
  });
}
