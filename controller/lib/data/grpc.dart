import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:monarch_utils/log.dart';
import 'channel_methods_sender.dart';

final _logger = Logger('ControllerGrpc');

void setUpGrpc(int cliServerPort) async {
  var server = Server([ControllerService()]);
  await server.serve(port: 0);
  var controllerServerPort = server.port!;
  _logger.info('controller grpc server started on port $controllerServerPort');

  cliGrpcClientInstance.initialize(port: cliServerPort);
  cliGrpcClientInstance.client!
      .controllerGrpcServerStarted(ServerInfo(port: controllerServerPort));
}

class CliGrpcClient {
  MonarchCliClient? client;
  bool get isClientInitialized => client != null;

  void initialize({required int port}) {
    _logger.info('Will use cli grpc server at port $port');
    var channel = ClientChannel(
        valueForPlatform(macos: '0.0.0.0', windows: 'localhost'),
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    client = MonarchCliClient(channel);
  }
}

final cliGrpcClientInstance = CliGrpcClient();

/// @TODO: all of this would move to MonarchPreviewApi service
class ControllerService extends MonarchControllerServiceBase {
  @override
  Future<Empty> restartPreview(ServiceCall call, Empty request) {
    channelMethodsSender.restartPreview();
    return Future.value(Empty());
  }

  @override
  Future<ReloadResponse> hotReload(ServiceCall call, Empty request) async {
    var isSuccessful = await channelMethodsSender.hotReload();
    return ReloadResponse(isSuccessful: isSuccessful);
  }
}
