import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

import '../analytics/analytics.dart';
import 'task_runner.dart';

class PreviewNotificationsApiService extends MonarchPreviewNotificationsApiServiceBase {
  final TaskRunner taskRunner;
  final Analytics analytics;

  PreviewNotificationsApiService(this.taskRunner, this.analytics);
  @override
  Future<Empty> defaultTheme(ServiceCall call, ThemeInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> deviceDefinitions(ServiceCall call, DeviceListInfo request) {
    // TODO: implement deviceDefinitions
    throw UnimplementedError();
  }

  @override
  Future<Empty> launchDevTools(ServiceCall call, Empty request) {
    // TODO: implement launchDevTools
    throw UnimplementedError();
  }

  @override
  Future<Empty> previewReady(ServiceCall call, Empty request) {
    // do nothing
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

  @override
  Future<Empty> scaleDefinitions(ServiceCall call, ScaleListInfo request) {
    // TODO: implement scaleDefinitions
    throw UnimplementedError();
  }

  @override
  Future<Empty> standardThemes(ServiceCall call, ThemeListInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> toggleVisualDebugFlag(ServiceCall call, VisualDebugFlagInfo request) {
    // TODO: implement toggleVisualDebugFlag
    throw UnimplementedError();
  }

  @override
  Future<Empty> trackUserSelection(ServiceCall call, UserSelectionData request) {
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
    taskRunner.attachTask!.debugUri = Uri(
        scheme: request.scheme,
        host: request.host,
        port: request.port,
        path: request.path);

    return Future.value(Empty());
  }
  
}