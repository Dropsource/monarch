import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

final _logger = Logger('CliGrpc');

const _startError = -1;

class CliGrpcServer {
  late Completer<int> _completer;
  Future<int> get port => _completer.future;

  Future<void> startServer() async {
    _completer = Completer();
    try {
      var server = Server([CliService()]);
      _logger.info('Starting cli grpc server');
      await server.serve(port: 0);
      _completer.complete(server.port!);
      _logger.info('cli grpc server started on port ${await port}');
    } catch (e, s) {
      _logger.severe('Error while starting cli grpc server', e, s);
      _completer.complete(_startError);
    }
  }

  Future<bool> started() async => (await port) != _startError;
}

class ControllerGrpcClient {
  MonarchControllerClient? client;
  bool get isClientInitialized => client != null;

  void initialize({required int port}) {
    _logger.info('Will use controller grpc server at port $port');
    var channel = ClientChannel('0.0.0.0',
        port: port,
        options: const ChannelOptions(credentials: ChannelCredentials.insecure()));
    client = MonarchControllerClient(channel);
  }
}

class CliService extends MonarchCliServiceBase {
  final controllerGrpcClient = ControllerGrpcClient();

  @override
  Future<Empty> controllerGrpcServerStarted(
      ServiceCall call, ServerInfo request) {
    controllerGrpcClient.initialize(port: request.port);
    return Future.value(Empty());
  }

  @override
  Future<Empty> launchDevTools(ServiceCall call, Empty request) {
    // TODO: implement launchDevTools
    throw UnimplementedError();
  }
}
