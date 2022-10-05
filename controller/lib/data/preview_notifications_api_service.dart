import 'package:grpc/grpc.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

import '../main.dart';

class PreviewNotificationsApiService
    extends MonarchPreviewNotificationsApiServiceBase {
  @override
  Future<Empty> defaultTheme(ServiceCall call, ThemeInfo request) {
    manager.onDefaultThemeChange(request.id);
    return Future.value(Empty());
  }

  // @override
  // Future<Empty> deviceDefinitions(ServiceCall call, DeviceListInfo request) {
  //   manager.onDeviceDefinitionsChanged(request.devices
  //       .map((e) => DeviceDefinition(
  //           id: e.id,
  //           name: e.name,
  //           logicalResolution: LogicalResolution(
  //               height: e.logicalResolutionInfo.height,
  //               width: e.logicalResolutionInfo.width),
  //           devicePixelRatio: e.devicePixelRatio,
  //           targetPlatform: targetPlatformFromString(e.targetPlatform)))
  //       .toList());
  //   return Future.value(Empty());
  // }

  @override
  Future<Empty> previewReady(ServiceCall call, Empty request) {
    if (!manager.state.isPreviewReady) {
      manager.onPreviewReady();
    }
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectPackage(ServiceCall call, PackageInfo request) {
    manager.onPackageNameChanged(request.name);
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectStories(ServiceCall call, StoriesMapInfo request) {
    manager.onProjectStoriesChanged(request.storiesMap.map((key, value) =>
        MapEntry(
            key,
            MetaStoriesDefinition(
                package: value.package,
                path: value.path,
                storiesNames: value.storiesNames))));
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectThemes(ServiceCall call, ThemeListInfo request) {
    manager.onProjectThemesChanged(request.themes
        .map((e) =>
            MetaThemeDefinition(id: e.id, name: e.name, isDefault: e.isDefault))
        .toList());
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectLocalizations(
      ServiceCall call, LocalizationListInfo request) {
    manager.onProjectLocalesChanged(request.localizations
        .map((e) => MetaLocalizationDefinition(
            localeLanguageTags: e.localeLanguageTags,
            delegateClassName: e.delegateClassName))
        .toList());
    throw UnimplementedError();
  }

  // @override
  // Future<Empty> scaleDefinitions(ServiceCall call, ScaleListInfo request) {
  //  manager.onStoryScaleDefinitionsChanged(scaleDefinitions);
  //   // TODO: implement scaleDefinitions
  //   return Future.value(Empty());
  // }

  // @override
  // Future<Empty> standardThemes(ServiceCall call, ThemeListInfo request) {
  //   manager.onStandardThemesChanged(request.themes
  //       .map((e) =>
  //           MetaThemeDefinition(id: e.id, name: e.name, isDefault: e.isDefault))
  //       .toList());
  //   return Future.value(Empty());
  // }

  @override
  Future<Empty> toggleVisualDebugFlag(
      ServiceCall call, VisualDebugFlagInfo request) {
    manager.onVisualDebugFlagToggleByVmService(request.name, request.isEnabled);
    return Future.value(Empty());
  }

  @override
  Future<Empty> trackUserSelection(
      ServiceCall call, UserSelectionData request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> userMessage(ServiceCall call, UserMessageInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> vmServerUri(ServiceCall call, UriInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> launchDevTools(ServiceCall call, Empty request) {
    // do nothing
    return Future.value(Empty());
  }
}
