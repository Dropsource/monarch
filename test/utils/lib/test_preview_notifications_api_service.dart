import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';


class TestPreviewNotificationsApiService
    extends MonarchPreviewNotificationsApiServiceBase {

  Completer<ProjectDataInfo> projectDataChangedReady = Completer();
  Completer<SelectionsStateInfo> selectionsStateChangedReady = Completer();

  TestPreviewNotificationsApiService();

  @override
  Future<Empty> vmServerUri(ServiceCall call, UriInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectDataChanged(ServiceCall call, ProjectDataInfo request) {
    projectDataChangedReady.complete(request);
    projectDataChangedReady = new Completer();
    return Future.value(Empty());
  }

  @override
  Future<Empty> selectionsStateChanged(
      ServiceCall call, SelectionsStateInfo request) {
    selectionsStateChangedReady.complete(request);
    selectionsStateChangedReady = new Completer();
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
