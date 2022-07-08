import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

final _logger = Logger('ControllerGrpc');

void setUpGrpc(int cliServerPort) async {
  var server = Server([ControllerService()]);
  await server.serve(port: 0);
  var controllerServerPort = server.port!;
  _logger.info('controller grpc server started on port $controllerServerPort');

  cliGrpcClient.initialize(port: cliServerPort);
  cliGrpcClient.client!
      .controllerGrpcServerStarted(ServerInfo(port: controllerServerPort));
}

class CliGrpcClient {
  MonarchCliClient? client;
  bool get isClientInitialized => client != null;

  void initialize({required int port}) {
    _logger.info('Will use cli grpc server at port $port');
    var channel = ClientChannel('0.0.0.0',
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    client = MonarchCliClient(channel);
  }
}

final cliGrpcClient = CliGrpcClient();

class ControllerService extends MonarchControllerServiceBase {
  @override
  Future<Empty> restartPreview(ServiceCall call, Empty request) {
    // TODO: implement restartPreview
    throw UnimplementedError();
  }
}
