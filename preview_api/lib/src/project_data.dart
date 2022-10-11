import 'dart:async';

import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

class ProjectData {
  final String packageName;
  final Map<String, MetaStoriesDefinition> storiesMap;
  final List<MetaThemeDefinition> projectThemes;
  final List<MetaLocalizationDefinition> localizations;

  ProjectData(
      {required this.packageName,
      required this.storiesMap,
      required this.projectThemes,
      required this.localizations});

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
