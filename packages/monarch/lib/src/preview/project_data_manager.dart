import 'package:monarch_utils/log.dart';

import '../builders/builder_helper.dart';
import 'active_theme.dart';
import 'project_data.dart';
import 'standard_themes.dart';
import 'channel_methods_sender.dart';

class ProjectDataManager with Log {
  ProjectData? _data;
  ProjectData? get data => _data;

  final List<String> _validationMessages = [];

  void load(ProjectData Function() getData) {
    var data = getData();

    var validatedMetaStories =
        _validateAndFilterMetaStories(data.metaStoriesMap);

    var validatedMetaLocalizations =
        _validateAndFilterMetaLocalizations(data.metaLocalizations);
    var validatedMetaThemes = _validateAndFilterMetaThemes(data.metaThemes);

    _data = ProjectData(data.packageName, validatedMetaLocalizations,
        validatedMetaThemes, validatedMetaStories);

    activeTheme.setMetaThemes([..._data!.metaThemes, ...standardMetaThemes]);
  }

  Map<String, MetaStories> _validateAndFilterMetaStories(
      Map<String, MetaStories> metaStoriesMap) {
    for (var entry in metaStoriesMap.entries) {
      var metaStories = entry.value;
      metaStories.storiesMap.removeWhere((storyName, storyFunction) {
        if (storyFunction == null) {
          _validationMessages.add('''
$monarchWarningBegin
Function `$storyName` is not of a story function of type `Widget Function()`. It will be ignored.
$monarchWarningEnd
''');
          metaStories.storiesNames
              .removeWhere((element) => element == storyName);
          return true;
        } else {
          log.fine('Valid story found: ${metaStories.path} > $storyName');
          return false;
        }
      });
    }
    return metaStoriesMap;
  }

  List<MetaLocalization> _validateAndFilterMetaLocalizations(
      List<MetaLocalization> metaLocalizationList) {
    final list = <MetaLocalization>[];
    for (var item in metaLocalizationList) {
      if (item.delegate == null) {
        _validationMessages.add('''
$monarchWarningBegin
Type of `${item.delegateClassName}` doesn't extend `LocalizationsDelegate<T>`. It will be ignored.
$monarchWarningEnd
''');
      } else if (item.locales.isEmpty) {
        _validationMessages.add('''
$monarchWarningBegin
`@MonarchLocalizations` annotation on `${item.delegateClassName}` doesn't declare any locales. It will 
be ignored.
$monarchWarningEnd
''');
      } else {
        log.fine(
            'Valid localization found on class ${item.delegateClassName} with '
            'annotated locales: ${item.locales.map((e) => e.languageCode).toList()}');
        list.add(item);
      }
    }
    return list;
  }

  List<MetaTheme> _validateAndFilterMetaThemes(List<MetaTheme> metaThemeList) {
    final list = <MetaTheme>[];
    for (var item in metaThemeList) {
      if (item.theme == null) {
        _validationMessages.add('''
$monarchWarningBegin
Theme `${item.name}` is not of type `ThemeData`. It will be ignored.
$monarchWarningEnd
''');
      } else {
        log.fine('Valid theme found: ${item.name}');
        list.add(item);
      }
    }
    return list;
  }

  Future<void> sendChannelMethods() async {
    for (var message in _validationMessages) {
      await channelMethodsSender.sendUserMessage(message);
    }
    _validationMessages.clear();

    await channelMethodsSender.sendProjectData(_data!);
    await channelMethodsSender.getState();
  }
}

final projectDataManager = ProjectDataManager();
