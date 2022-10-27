import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

Logger _logger = Logger('PreviewApiClient');

Future<MonarchPreviewApiClient?> getPreviewApiClient(
    MonarchDiscoveryApiClient discoveryClient) async {
  const maxRetries = 10;

  Future<int> getPreviewApiPort() async {
    var serverInfo = await discoveryClient.getPreviewApi(Empty());
    return serverInfo.hasPort() ? serverInfo.port : -1;
  }

  for (var i = 0; i < maxRetries; i++) {
    int port = await getPreviewApiPort();
    if (port > -1) {
      var channel = constructClientChannel(port);
      return MonarchPreviewApiClient(channel);
    }
    await Future.delayed(const Duration(milliseconds: 50));
  }

  _logger.warning(
      'Monarch Controller could not get Preview API port from Discovery API after $maxRetries attempts.');
  return null;
}
