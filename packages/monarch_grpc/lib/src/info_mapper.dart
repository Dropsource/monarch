import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

/// It maps a Monarch definition object to a Monarch grpc message (i.e. Info object).
abstract class InfoMapper<I, D> {
  I toInfo(D def);

  D fromInfo(I info);
}

class LogicalResolutionInfoMapper
    implements InfoMapper<LogicalResolutionInfo, LogicalResolution> {
  @override
  LogicalResolution fromInfo(LogicalResolutionInfo info) => LogicalResolution(
        height: info.height,
        width: info.width,
      );

  @override
  LogicalResolutionInfo toInfo(LogicalResolution def) => LogicalResolutionInfo(
        height: def.height,
        width: def.width,
      );
}

class DeviceInfoMapper implements InfoMapper<DeviceInfo, DeviceDefinition> {
  @override
  DeviceDefinition fromInfo(DeviceInfo info) => DeviceDefinition(
        id: info.id,
        name: info.name,
        logicalResolution:
            LogicalResolutionInfoMapper().fromInfo(info.logicalResolutionInfo),
        devicePixelRatio: info.devicePixelRatio,
        targetPlatform: targetPlatformFromString(info.targetPlatform),
      );

  @override
  DeviceInfo toInfo(DeviceDefinition def) => DeviceInfo(
        id: def.id,
        name: def.name,
        targetPlatform: targetPlatformToString(def.targetPlatform),
        logicalResolutionInfo:
            LogicalResolutionInfoMapper().toInfo(def.logicalResolution),
        devicePixelRatio: def.devicePixelRatio,
      );
}

class ThemeInfoMapper implements InfoMapper<ThemeInfo, MetaThemeDefinition> {
  @override
  MetaThemeDefinition fromInfo(ThemeInfo info) => MetaThemeDefinition(
        id: info.id,
        name: info.name,
        isDefault: info.isDefault,
      );

  @override
  ThemeInfo toInfo(MetaThemeDefinition def) => ThemeInfo(
        id: def.id,
        name: def.name,
        isDefault: def.isDefault,
      );
}

class ScaleInfoMapper implements InfoMapper<ScaleInfo, StoryScaleDefinition> {
  @override
  StoryScaleDefinition fromInfo(ScaleInfo info) => StoryScaleDefinition(
        scale: info.scale,
        name: info.name,
      );

  @override
  ScaleInfo toInfo(StoryScaleDefinition def) => ScaleInfo(
        scale: def.scale,
        name: def.name,
      );
}

class VisualDebugFlagInfoMapper
    implements InfoMapper<VisualDebugFlagInfo, VisualDebugFlag> {
  @override
  VisualDebugFlag fromInfo(VisualDebugFlagInfo info) => VisualDebugFlag(
        name: info.name,
        isEnabled: info.isEnabled,
      );

  @override
  VisualDebugFlagInfo toInfo(VisualDebugFlag def) => VisualDebugFlagInfo(
        name: def.name,
        isEnabled: def.isEnabled,
      );
}

class LocalizationInfoMapper
    implements InfoMapper<LocalizationInfo, MetaLocalizationDefinition> {
  @override
  MetaLocalizationDefinition fromInfo(LocalizationInfo info) =>
      MetaLocalizationDefinition(
        localeLanguageTags: info.localeLanguageTags,
        delegateClassName: info.delegateClassName,
      );

  @override
  LocalizationInfo toInfo(MetaLocalizationDefinition def) => LocalizationInfo(
        localeLanguageTags: def.localeLanguageTags,
        delegateClassName: def.delegateClassName,
      );
}

class DockInfoMapper implements InfoMapper<DockInfo, DockDefinition> {
  @override
  DockDefinition fromInfo(DockInfo info) => DockDefinition(
        id: info.id,
        name: info.name,
      );

  @override
  DockInfo toInfo(DockDefinition def) => DockInfo(
        id: def.name,
        name: def.name,
      );
}

class StoriesInfoMapper
    implements InfoMapper<StoriesInfo, MetaStoriesDefinition> {
  @override
  MetaStoriesDefinition fromInfo(StoriesInfo info) => MetaStoriesDefinition(
      package: info.package, path: info.path, storiesNames: info.storiesNames);

  @override
  StoriesInfo toInfo(MetaStoriesDefinition def) => StoriesInfo(
      package: def.package, path: def.path, storiesNames: def.storiesNames);
}

class ProjectDataInfoMapper
    implements InfoMapper<ProjectDataInfo, MonarchDataDefinition> {
  @override
  MonarchDataDefinition fromInfo(ProjectDataInfo info) => MonarchDataDefinition(
      packageName: info.packageName,
      metaLocalizationDefinitions: info.localizations
          .map((e) => LocalizationInfoMapper().fromInfo(e))
          .toList(),
      metaThemeDefinitions:
          info.projectThemes.map((e) => ThemeInfoMapper().fromInfo(e)).toList(),
      metaStoriesDefinitionMap: info.storiesMap.map(
          (key, value) => MapEntry(key, StoriesInfoMapper().fromInfo(value))));

  @override
  ProjectDataInfo toInfo(MonarchDataDefinition def) => ProjectDataInfo(
      packageName: def.packageName,
      localizations: def.metaLocalizationDefinitions
          .map((e) => LocalizationInfoMapper().toInfo(e)),
      projectThemes:
          def.metaThemeDefinitions.map((e) => ThemeInfoMapper().toInfo(e)),
      storiesMap: def.metaStoriesDefinitionMap.map(
          (key, value) => MapEntry(key, StoriesInfoMapper().toInfo(value))));
}

class StoryIdInfoMapper implements InfoMapper<StoryIdInfo, StoryId> {
  @override
  StoryId fromInfo(StoryIdInfo info) => StoryId(
      storiesMapKey: info.storiesMapKey,
      package: info.package,
      path: info.path,
      storyName: info.storyName);

  @override
  StoryIdInfo toInfo(StoryId def) => StoryIdInfo(
      storiesMapKey: def.storiesMapKey,
      package: def.package,
      path: def.path,
      storyName: def.storyName);
}
