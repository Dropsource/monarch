import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

class PreviewApi with Log {
  final MonarchDiscoveryApiClient discoveryApi;

  PreviewApi(this.discoveryApi);

  MonarchPreviewApiClient? _client;

  /// Lazily returns a preview api client if the discovery
  /// api has the information of the preview api server.
  /// Otherwise it returns null.
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

  /// Returns true if the preview api client is available.
  Future<bool> isAvailable() async {
    var client = await getClient();
    return client != null;
  }

  /// Uses the vm service of the preview window to request a hot reload.
  /// Assumes [isAvailable] has returned true.
  Future<bool> hotReload() async {
    var client = await getClient();
    var response = await client!.hotReload(Empty());
    return response.isSuccessful;
  }

  /// Signals the platform code that the preview will restart.
  /// Implemented on Windows.
  /// Assumes [isAvailable] has returned true.
  Future<void> willRestartPreview() async {
    var client = await getClient();
    await client!.willRestartPreview(Empty());
  }

  /// Restars the preview window via platform code.
  /// Assumes [isAvailable] has returned true.
  Future<void> restartPreview() async {
    var client = await getClient();
    await client!.restartPreview(Empty());
  }

  /// Terminates the preview app via platform code.
  ///
  /// If you call this function during the sigint handler on macOS
  /// you may see error messages appear since this function makes grpc calls.
  /// On 2022-10-26, macOS did not allow grpc calls from the sigint handler.
  /// We were getting errors like:
  /// ```
  /// message: HTTP/2 error: Connection error: Connection is being forcefully terminated. (errorCode: 10)
  /// ```
  Future<void> terminatePreview() async {
    var client = await getClient();
    await client!.terminatePreview(Empty());
  }
}
