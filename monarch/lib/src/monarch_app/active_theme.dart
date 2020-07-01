import 'dart:async';

import 'package:dropsource_storybook_utils/log.dart';

import 'storybook_data.dart';

class ActiveTheme with Log {
  final List<MetaTheme> _metaThemes = [];
  List<MetaTheme> get metaThemes => _metaThemes;

  MetaTheme _defaultMetaTheme;
  MetaTheme get defaultMetaTheme => _defaultMetaTheme;

  MetaTheme _activeMetaTheme;
  MetaTheme get activeMetaTheme => _activeMetaTheme ?? _defaultMetaTheme;

  final _activeMetaThemeStreamController =
      StreamController<void>.broadcast();
  Stream<void> get activeMetaThemeStream =>
      _activeMetaThemeStreamController.stream;

  void setMetaThemes(List<MetaTheme> list) {
    if (list.isEmpty) {
      throw ArgumentError('meta theme list must not be empty');
    }

    _metaThemes.clear();
    _metaThemes.addAll(list);

    _defaultMetaTheme = _metaThemes.firstWhere(
        (metaTheme) => metaTheme.isDefault,
        orElse: () => _metaThemes.first);
  }

  void setActiveMetaTheme(String id) {
    if (metaThemes.isEmpty) {
      throw StateError('setMetaThemes must be called first');
    }

    _activeMetaTheme = metaThemes.firstWhere((metaTheme) => metaTheme.id == id,
        orElse: () =>
            throw ArgumentError('expected to find meta theme with id $id'));
    
    _activeMetaThemeStreamController.add(null);
    log.fine('active theme id set: ${_activeMetaTheme.id}');
  }

  void resetActiveMetaTheme() {
    _activeMetaTheme = defaultMetaTheme;
  }

  void close() {
    _activeMetaThemeStreamController.close();
  }
}

final activeTheme = ActiveTheme();
