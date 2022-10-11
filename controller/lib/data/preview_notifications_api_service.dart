import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

import '../manager/controller_manager.dart';

class PreviewNotificationsApiService
    extends MonarchPreviewNotificationsApiServiceBase {

  final ControllerManager manager;

  PreviewNotificationsApiService(this.manager);

  @override
  Future<Empty> previewReady(ServiceCall call, Empty request) {
    if (!manager.state.isPreviewReady) {
      manager.onPreviewReady();
    }
    return Future.value(Empty());
  }

  @override
  Future<Empty> vmServerUri(ServiceCall call, UriInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectDataChanged(ServiceCall call, ProjectDataInfo request) {
    manager.onProjectDataChanged(
        packageName: request.packageName,
        storiesMap: request.storiesMap.map(
            (key, value) => MapEntry(key, StoriesInfoMapper().fromInfo(value))),
        projectThemes: request.projectThemes
            .map((e) => ThemeInfoMapper().fromInfo(e))
            .toList(),
        localizations: request.localizations
            .map((e) => LocalizationInfoMapper().fromInfo(e))
            .toList());
    return Future.value(Empty());
  }

  @override
  Future<Empty> selectionsStateChanged(
      ServiceCall call, SelectionsStateInfo request) {
    manager.onSelectionsStateChanged(
        storyKey: request.hasStoryKey() ? request.storyKey : null,
        device: DeviceInfoMapper().fromInfo(request.device),
        theme: ThemeInfoMapper().fromInfo(request.theme),
        locale: request.locale.languageTag,
        scale: ScaleInfoMapper().fromInfo(request.scale),
        textScaleFactor: request.textScaleFactor,
        dock: DockInfoMapper().fromInfo(request.dock),
        visualDebugFlags: request.visualDebugFlags);
    return Future.value(Empty());
  }

  @override
  Future<Empty> userMessage(ServiceCall call, UserMessageInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> launchDevTools(ServiceCall call, Empty request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> trackUserSelection(
      ServiceCall call, UserSelectionData request) {
    // do nothing
    return Future.value(Empty());
  }
}
