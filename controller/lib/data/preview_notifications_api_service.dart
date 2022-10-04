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
  Future<Empty> launchDevTools(ServiceCall call, Empty request) {
    // TODO: implement launchDevTools
    throw UnimplementedError();
  }

  @override
  Future<Empty> previewReady(ServiceCall call, Empty request) {
    if (!manager.state.isPreviewReady) {
      manager.onPreviewReady();
    }
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectLocales(ServiceCall call, LocaleListInfo request) {
    // TODO: implement projectLocales
    throw UnimplementedError();
  }

  @override
  Future<Empty> projectName(ServiceCall call, ProjectNameInfo request) {
    // TODO: implement projectName
    throw UnimplementedError();
  }

  @override
  Future<Empty> projectStories(ServiceCall call, StoriesMapInfo request) {
    // TODO: implement projectStories
    throw UnimplementedError();
  }

  @override
  Future<Empty> projectThemes(ServiceCall call, ThemeListInfo request) {
    // TODO: implement projectThemes
    throw UnimplementedError();
  }

  // @override
  // Future<Empty> scaleDefinitions(ServiceCall call, ScaleListInfo request) {
  //   // TODO: implement scaleDefinitions
  //   throw UnimplementedError();
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
    // TODO: implement toggleVisualDebugFlag
    throw UnimplementedError();
  }

  @override
  Future<Empty> trackUserSelection(
      ServiceCall call, UserSelectionData request) {
    // TODO: implement trackUserSelection
    throw UnimplementedError();
  }

  @override
  Future<Empty> userMessage(ServiceCall call, UserMessageInfo request) {
    // TODO: implement userMessage
    throw UnimplementedError();
  }

  @override
  Future<Empty> vmServerUri(ServiceCall call, UriInfo request) {
    // do nothing
    return Future.value(Empty());
  }
}
