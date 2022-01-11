import 'package:monarch_utils/log.dart';

import '../builders/builder_helper.dart';
import 'active_theme.dart';
import 'monarch_data.dart';
import 'standard_themes.dart';
import 'user_message.dart';

final _logger = Logger('MonarchDataInstance');

late MonarchData _monarchDataInstance;
MonarchData get monarchDataInstance => _monarchDataInstance;

void loadMonarchDataInstance(MonarchData Function() getData) {
  var data = getData();

  var validatedMetaLocalizations =
      _validateAndFilterMetaLocalizations(data.metaLocalizations);
  var validatedMetaThemes = _validateAndFilterMetaThemes(data.metaThemes);

  _monarchDataInstance = MonarchData(data.packageName,
      validatedMetaLocalizations, validatedMetaThemes, data.metaStoriesMap);

  activeTheme.setMetaThemes(
      [...monarchDataInstance.metaThemes, ...standardMetaThemes]);
}

List<MetaLocalization> _validateAndFilterMetaLocalizations(
    List<MetaLocalization> metaLocalizationList) {
  final _list = <MetaLocalization>[];
  for (var item in metaLocalizationList) {
    if (item.delegate == null) {
      printUserMessage('''
$monarchWarningBegin
Type of `${item.delegateClassName}` doesn't extend `LocalizationsDelegate<T>`. It will be ignored.
$monarchWarningEnd
''');
    } else if (item.locales.isEmpty) {
      printUserMessage('''
$monarchWarningBegin
`@MonarchLocalizations` annotation on `${item.delegateClassName}` doesn't declare any locales. It will 
be ignored.
$monarchWarningEnd
''');
    } else {
      _logger.fine(
          'Valid localization found on class ${item.delegateClassName} with '
          'annotated locales: ${item.locales.map((e) => e.languageCode).toList()}');
      _list.add(item);
    }
  }
  return _list;
}

List<MetaTheme> _validateAndFilterMetaThemes(List<MetaTheme> metaThemeList) {
  final _list = <MetaTheme>[];
  for (var item in metaThemeList) {
    if (item.theme == null) {
      printUserMessage('''
$monarchWarningBegin
Theme `${item.name}` is not of type `ThemeData`. It will be ignored.
$monarchWarningEnd
''');
    } else {
      _logger.fine('Valid theme found: ${item.name}');
      _list.add(item);
    }
  }
  return _list;
}
