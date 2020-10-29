import 'dart:async';
import 'dart:ui';

import 'package:monarch_utils/log.dart';

import 'localizations_delegate_loader.dart';

enum LocaleLoadingStatus { inProgress, done, error }

class ActiveLocale with Log {
  final LocalizationsDelegateLoader loader;

  ActiveLocale(this.loader);

  LocaleLoadingStatus loadingStatus;

  Locale _activeLocale;
  Locale get locale => _activeLocale;

  bool _canLoad;
  bool get canLoad => _canLoad;

  final _loadingStatusStreamController =
      StreamController<LocaleLoadingStatus>.broadcast();
  Stream<LocaleLoadingStatus> get loadingStatusStream =>
      _loadingStatusStreamController.stream;

  void setActiveLocale(Locale newLocale) async {
    _setStatus(LocaleLoadingStatus.inProgress);
    _activeLocale = newLocale;
    try {
      _canLoad = await loader.canLoad(_activeLocale);
      _setStatus(LocaleLoadingStatus.done);
      log.fine('active locale loaded: $_activeLocale');
    } catch (e, s) {
      _canLoad = false;
      log.severe('Unexpected error while loading locale $_activeLocale', e, s);
      _setStatus(LocaleLoadingStatus.error);
    }
  }

  void resetActiveLocale() {
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

  void setActiveLocaleTag(String localeTag) {
    if (localeTag == 'System Locale') {
      // As of 2020-10-08, the platform apps send 'System Locale' when there aren't
      // any user-defined locales, in which case the StoryApp will create a MaterialApp
      // without any localization data. In this case, Flutter's default behavior is to
      // use the only supported locale which is en-US.
      resetActiveLocale();
    } else {
      setActiveLocale(parseLocale(localeTag));
    }
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

ActiveLocale activeLocale;
