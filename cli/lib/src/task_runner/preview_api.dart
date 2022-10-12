import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

class PreviewApi with Log {
  final MonarchDiscoveryApiClient discoveryApi;

  PreviewApi(this.discoveryApi);

  MonarchPreviewApiClient? _client;
  Future<MonarchPreviewApiClient?> getClient() async {
    if (_client == null) {
      var serverInfo = await discoveryApi.getPreviewApi(Empty());
      if (serverInfo.hasPort()) {
        var channel = constructClientChannel(serverInfo.port);
        _client = MonarchPreviewApiClient(channel);
      }
    }
    return _client;
  }

  Future<bool> isClientInitialized() async {
    var client = await getClient();
    return client != null;
  }

  Future<bool> hotReload() async {
    var client = await getClient();
    var response = await client!.hotReload(Empty());
    return response.isSuccessful;
  }

  Future<void> restartPreview() async {
    var client = await getClient();
    client!.restartPreview(Empty());
  }
}
