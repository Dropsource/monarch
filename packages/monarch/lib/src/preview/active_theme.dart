import 'active_value.dart';
import 'project_data.dart';
import 'standard_themes.dart';

class ActiveTheme extends ActiveValue<MetaTheme> {
  final List<MetaTheme> _metaThemes = [];
  List<MetaTheme> get metaThemes => _metaThemes;

  MetaTheme? _activeMetaTheme;
  @override
  MetaTheme get value => _activeMetaTheme ?? defaultTheme;

  void setMetaThemes(List<MetaTheme> list) {
    if (list.isEmpty) {
      throw ArgumentError('meta theme list must not be empty');
    }

    _metaThemes.clear();
    _metaThemes.addAll(list);
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
