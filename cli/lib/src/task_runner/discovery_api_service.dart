import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

class DiscoveryApiService extends MonarchDiscoveryApiServiceBase {
  int? _previewApiPort;
  final List<int> _notificationsApiPorts = [];

  @override
  Future<Empty> registerPreviewApi(ServiceCall call, ServerInfo request) {
    _previewApiPort = request.port;
    return Future.value(Empty());
  }

  @override
  Future<Empty> registerPreviewNotificationsApi(
      ServiceCall call, ServerInfo request) {
    _notificationsApiPorts.add(request.port);
    return Future.value(Empty());
  }

  @override
  Future<ServerInfo> getPreviewApi(ServiceCall call, Empty request) {
    return Future.value(ServerInfo(port: _previewApiPort));
  }

  @override
  Future<ServerListInfo> getPreviewNotificationsApiList(
      ServiceCall call, Empty request) {
    return Future.value(ServerListInfo(
        servers: _notificationsApiPorts.map((e) => ServerInfo(port: e))));
  }
}
