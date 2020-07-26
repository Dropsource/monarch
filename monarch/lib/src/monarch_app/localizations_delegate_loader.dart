import 'package:flutter/widgets.dart';
import 'package:monarch/monarch.dart';
import 'package:monarch_utils/log.dart';

import 'user_message.dart';

class LocalizationsDelegateLoader with Log {
  final List<MetaLocalization> metaLocalizations;

  LocalizationsDelegateLoader(this.metaLocalizations);

  final _map = <Type, Map<Locale, _LoadResult>>{};

  Future<bool> canLoad(Locale locale) async {
    for (var item in metaLocalizations) {
      final result = await _canLoadSingleDelegate(locale, item.delegate);
      if (!result.didLoadSuccessfully) {
        printUserMessage('''
Error: LocalizationsDelegate ${item.delegate.type} could not load locale ${locale.toLanguageTag()}
${result.error}
${result.stackTrace}
''');
        return false;
      }
    }
    return true;
  }

  Future<_LoadResult> _canLoadSingleDelegate(
      Locale locale, LocalizationsDelegate delegate) async {
    if (_hasLocaleKey(delegate.type, locale)) {
      return Future.microtask(() => _map[delegate.type][locale]);
    } else {
      _map[delegate.type] = _map[delegate.type] ?? <Locale, _LoadResult>{};
      try {
        await delegate.load(locale);
        _map[delegate.type][locale] = _LoadResult.success();
        log.fine('Successfully loaded LocalizationsDelegate ${delegate.type} '
            'with locale $locale');
      } catch (e, s) {
        _map[delegate.type][locale] = _LoadResult.failure(e, s);
        log.fine('Failed to load LocalizationsDelegate ${delegate.type} '
            'with locale $locale');
      }
      return _map[delegate.type][locale];
    }
  }

  bool _hasLocaleKey(Type type, Locale locale) {
    return _map.containsKey(type) && _map[type].containsKey(locale);
  }
}

class _LoadResult {
  final bool didLoadSuccessfully;
  final dynamic error;
  final StackTrace stackTrace;

  _LoadResult._(this.didLoadSuccessfully, this.error, this.stackTrace);

  _LoadResult.success() : this._(true, null, null);

  _LoadResult.failure(dynamic error, StackTrace stackTrace)
      : this._(false, error, stackTrace);
}
