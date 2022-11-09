import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

import '../manager/controller_manager.dart';

class PreviewNotificationsApiService
    extends MonarchPreviewNotificationsApiServiceBase {
  final ControllerManager manager;

  PreviewNotificationsApiService(this.manager);

  @override
  Future<Empty> vmServerUri(ServiceCall call, UriInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectDataChanged(ServiceCall call, ProjectDataInfo request) {
    manager.projectDataChanged(request);
    return Future.value(Empty());
  }

  @override
  Future<Empty> selectionsStateChanged(
      ServiceCall call, SelectionsStateInfo request) {
    manager.selectionsStateChanged(request);
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
