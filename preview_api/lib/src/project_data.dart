import 'dart:async';

import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

class ProjectData extends MonarchDataDefinition {
  ProjectData({
    required String packageName,
    required Map<String, MetaStoriesDefinition> storiesMap,
    required List<MetaThemeDefinition> projectThemes,
    required List<MetaLocalizationDefinition> localizations,
  }) : super(
            packageName: packageName,
            metaStoriesDefinitionMap: storiesMap,
            metaThemeDefinitions: projectThemes,
            metaLocalizationDefinitions: localizations);

  Map<String, MetaStoriesDefinition> get storiesMap => metaStoriesDefinitionMap;
  List<MetaThemeDefinition> get projectThemes => metaThemeDefinitions;
  List<MetaLocalizationDefinition> get localizations => metaLocalizationDefinitions;

  factory ProjectData.init() => ProjectData(
      packageName: '', storiesMap: {}, projectThemes: [], localizations: []);

  ProjectDataInfo toInfo() => ProjectDataInfo(
      packageName: packageName,
      storiesMap: storiesMap.map((key, value) => MapEntry(
          key,
          StoriesInfo(
              package: value.package,
              path: value.path,
              storiesNames: value.storiesNames))),
      projectThemes: projectThemes.map(
          (e) => ThemeInfo(id: e.id, name: e.name, isDefault: e.isDefault)),
      localizations: localizations.map((e) => LocalizationInfo(
          localeLanguageTags: e.localeLanguageTags,
          delegateClassName: e.delegateClassName)));
}

class ProjectDataManager {
  ProjectData _projectData = ProjectData.init();
  ProjectData get projectData => _projectData;

  final _controller = StreamController<ProjectData>.broadcast();
  Stream<ProjectData> get stream => _controller.stream;

  void update(ProjectData data) {
    _projectData = data;
    _controller.add(_projectData);
  }

  void close() {
    _controller.close();
  }
}
