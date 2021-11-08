import 'dart:async';
import 'dart:ui';

import 'package:monarch_utils/log.dart';

import 'locale_validator.dart';

enum LocaleLoadingStatus { initial, inProgress, done, error }

class ActiveLocale with Log {
  LocaleValidator localeValidator = LocaleValidator([]);

  ActiveLocale();

  LocaleLoadingStatus loadingStatus = LocaleLoadingStatus.initial;

  Locale? _activeLocale;
  Locale? get locale => _activeLocale;

  bool? _canLoad;
  bool? get canLoad => _canLoad;

  final _loadingStatusStreamController =
      StreamController<LocaleLoadingStatus>.broadcast();

  Stream<LocaleLoadingStatus> get loadingStatusStream =>
      _loadingStatusStreamController.stream;

  void setActiveLocaleTag(String localeTag) {
    if (localeTag == 'System Locale') {
      // As of 2020-10-08, the Monarch platform apps send 'System Locale' when there aren't
      // any user-defined locales, in which case the StoryApp will create a MaterialApp
      // without any localization data. In this case, Flutter's default behavior is to
      // use the only supported locale which is en-US.
      _resetActiveLocale();
    } else {
      _setActiveLocale(parseLocale(localeTag));
    }
  }

  void _setActiveLocale(Locale newLocale) async {
    _setStatus(LocaleLoadingStatus.inProgress);
    _activeLocale = newLocale;
    try {
      _canLoad = await localeValidator.canLoad(_activeLocale!);
      _setStatus(LocaleLoadingStatus.done);
      log.fine('active locale $_activeLocale validation (can load) is $_canLoad');
    } catch (e, s) {
      _canLoad = false;
      log.severe('Unexpected error while validating locale $_activeLocale', e, s);
      _setStatus(LocaleLoadingStatus.error);
    }
  }

  void _resetActiveLocale() {
    _activeLocale = null;
    log.fine('active locale reset');
  }

  void assertIsLoaded() {
    if (locale == null) {
      throw StateError('Expected activeLocale to be set');
    }
    if (canLoad == null) {
      throw StateError('Expected canLoad to be set');
    }
  }

  void _setStatus(LocaleLoadingStatus status) {
    loadingStatus = status;
    _loadingStatusStreamController.add(loadingStatus);
  }

  void close() {
    _loadingStatusStreamController.close();
  }
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
