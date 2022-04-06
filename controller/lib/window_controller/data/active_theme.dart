import 'active_value.dart';
import 'monarch_data.dart';

class ActiveTheme extends ActiveValue<MetaTheme> {
  final List<MetaTheme> _metaThemes = [];
  List<MetaTheme> get metaThemes => _metaThemes;

  late MetaTheme _defaultMetaTheme;
  MetaTheme get defaultMetaTheme => _defaultMetaTheme;

  MetaTheme? _activeMetaTheme;
  @override
  MetaTheme get value => _activeMetaTheme ?? _defaultMetaTheme;

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

  MetaTheme getMetaTheme(String id) =>
      metaThemes.firstWhere((metaTheme) => metaTheme.id == id,
          orElse: (() =>
              throw ArgumentError('expected to find meta theme with id $id')));

  @override
  void setValue(MetaTheme newValue) {
    _activeMetaTheme = newValue;
  }

  @override
  String get valueSetMessage => 'active theme id set: ${_activeMetaTheme!.id}';
}

final activeTheme = ActiveTheme();
