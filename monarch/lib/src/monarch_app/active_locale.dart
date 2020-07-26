import 'dart:async';
import 'dart:ui';

import 'package:monarch_utils/log.dart';

import 'localizations_delegate_loader.dart';

enum LoadingStatus { inProgress, done, error }

class ActiveLocale with Log {
  final LocalizationsDelegateLoader loader;

  ActiveLocale(this.loader);

  LoadingStatus loadingStatus;

  Locale _activeLocale;
  Locale get locale => _activeLocale;

  bool _canLoad;
  bool get canLoad => _canLoad;

  final _loadingStatusStreamController =
      StreamController<LoadingStatus>.broadcast();
  Stream<LoadingStatus> get loadingStatusStream =>
      _loadingStatusStreamController.stream;

  void setActiveLocale(Locale newLocale) async {
    _setStatus(LoadingStatus.inProgress);
    _activeLocale = newLocale;
    try {
      _canLoad = await loader.canLoad(_activeLocale);
      _setStatus(LoadingStatus.done);
      log.fine('active locale loaded: $_activeLocale');
    } catch (e, s) {
      _canLoad = false;
      log.severe('Unexpected error while loading locale $_activeLocale', e, s);
      _setStatus(LoadingStatus.error);
    }
  }

  void assertIsLoaded() {
    if (locale == null) {
      throw StateError('Expected activeLocale to be set');
    }
    if (canLoad == null) {
      throw StateError('Expected canLoad to be set');
    }
  }

  void _setStatus(LoadingStatus status) {
    loadingStatus = status;
    _loadingStatusStreamController.add(loadingStatus);
  }

  void setActiveLocaleTag(String localeTag) {
    setActiveLocale(parseLocale(localeTag));
  }

  void close() {
    _loadingStatusStreamController.close();
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

ActiveLocale activeLocale;
