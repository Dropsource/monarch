import 'package:monarch_utils/log.dart';

import 'monarch_data.dart';
import 'user_message.dart';

final _logger = Logger('MonarchDataInstance');

late MonarchData monarchDataInstance;

void loadMonarchDataInstance(MonarchData Function() getData) {
  var data = getData();

  var validatedMetaLocalizations =
      _validateAndFilterMetaLocalizations(data.metaLocalizations);
  var validatedMetaThemes = _validateAndFilterMetaThemes(data.metaThemes);

  monarchDataInstance = MonarchData(data.packageName,
      validatedMetaLocalizations, validatedMetaThemes, data.metaStoriesMap);
}

List<MetaLocalization> _validateAndFilterMetaLocalizations(
    List<MetaLocalization> metaLocalizationList) {
  final _list = <MetaLocalization>[];
  for (var item in metaLocalizationList) {
    if (item.delegate == null) {
      printUserMessage(
          'Info: ${item.delegateClassName} doesn\'t extend LocalizationsDelegate<T>. '
          'It will be ignored.');
    } else if (item.locales.isEmpty) {
      printUserMessage(
          'Info: @MonarchLocalizations annotation on ${item.delegateClassName} '
          'doesn\'t declare any locales. It will be ignored.');
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
      printUserMessage(
          'Info: Theme "${item.name}" is not of type ThemeData. It will be ignored.');
    } else {
      _logger.fine('Valid theme found: ${item.name}');
      _list.add(item);
    }
  }
  return _list;
}
