import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

class TestPreviewNotificationsApiService
    extends MonarchPreviewNotificationsApiServiceBase {
  final _projectDataStreamController =
      StreamController<ProjectDataInfo>.broadcast();
  Stream<ProjectDataInfo> get projectDataStream =>
      _projectDataStreamController.stream;

  final _selectionsStateStreamController =
      StreamController<SelectionsStateInfo>.broadcast();
  Stream<SelectionsStateInfo> get selectionsStateStream =>
      _selectionsStateStreamController.stream;

  TestPreviewNotificationsApiService();

  @override
  Future<Empty> vmServerUri(ServiceCall call, UriInfo request) {
    // do nothing
    return Future.value(Empty());
  }

  @override
  Future<Empty> projectDataChanged(ServiceCall call, ProjectDataInfo request) {
    _projectDataStreamController.add(request);
    return Future.value(Empty());
  }

  @override
  Future<Empty> selectionsStateChanged(
      ServiceCall call, SelectionsStateInfo request) {
    _selectionsStateStreamController.add(request);
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
