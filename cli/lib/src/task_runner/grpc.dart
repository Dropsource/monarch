import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import 'task_runner.dart';
import '../utils/standard_output.dart';

final _logger = Logger('CliGrpc');

class CliGrpcServer {
  late final int port;

  Future<void> startServer(TaskRunner taskRunner) async {
    var server = Server([CliService(taskRunner)]);
    _logger.info('Starting cli grpc server');
    await server.serve(port: 0);
    port = server.port!;
    _logger.info('cli grpc server started on port $port');
  }
}

class ControllerGrpcClient {
  MonarchControllerClient? client;
  bool get isClientInitialized => client != null;

  void initialize({required int port}) {
    _logger.info('Will use controller grpc server at port $port');
    var channel = ClientChannel('0.0.0.0',
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    client = MonarchControllerClient(channel);
  }
}

final controllerGrpcClientInstance = ControllerGrpcClient();

class CliService extends MonarchCliServiceBase {
  final TaskRunner taskRunner;
  CliService(this.taskRunner);

  @override
  Future<Empty> controllerGrpcServerStarted(
      ServiceCall call, ServerInfo request) {
    controllerGrpcClientInstance.initialize(port: request.port);
    return Future.value(Empty());
  }

  @override
  Future<Empty> launchDevTools(ServiceCall call, Empty request) {
    taskRunner.attachTask!.launchDevtools();
    return Future.value(Empty());
  }

  @override
  Future<Empty> previewVmServerUriChanged(ServiceCall call, UriInfo request) {
    taskRunner.attachTask!.debugUri = Uri(
        scheme: request.scheme,
        host: request.host,
        port: request.port,
        path: request.path);

    return Future.value(Empty());
  }
  
  @override
  Future<Empty> printUserMessage(ServiceCall call, UserMessage request) {
    stdout_default.writeln(request.message);
    return Future.value(Empty());
  }
}
