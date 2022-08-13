import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_io_utils/utils.dart';
import 'package:monarch_utils/log.dart';

import '../analytics/analytics.dart';
import 'task_runner.dart';
import '../utils/standard_output.dart';

final _logger = Logger('CliGrpc');

class CliGrpcServer {
  late final int port;

  Future<void> startServer(TaskRunner taskRunner, Analytics analytics) async {
    var server = Server([CliService(taskRunner, analytics)]);
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
    var channel = ClientChannel(valueForPlatform(macos: '0.0.0.0', windows: 'localhost'),
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    client = MonarchControllerClient(channel);
  }
}

final controllerGrpcClientInstance = ControllerGrpcClient();

class CliService extends MonarchCliServiceBase {
  final TaskRunner taskRunner;
  final Analytics analytics;

  CliService(this.taskRunner, this.analytics);

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

  @override
  Future<Empty> userSelection(ServiceCall call, UserSelectionData request) {
    analytics.user_selection({
      'locale_count': request.localeCount,
      'user_theme_count': request.userThemeCount,
      'story_count': request.storyCount,
      'selected_device': request.selectedDevice,
      'kind': request.kind,
      'selected_dock_side': request.selectedDockSide,
      'selected_text_scale_factor': request.selectedTextScaleFactor,
      'selected_story_scale': request.selectedStoryScale,
      'slow_animations_enabled': request.slowAnimationsEnabled,
      'show_guidelines_enabled': request.showGuidelinesEnabled,
      'show_baselines_enabled': request.showBaselinesEnabled,
      'highlight_repaints_enabled': request.highlightRepaintsEnabled,
      'highlight_oversized_images_enabled':
          request.highlightOversizedImagesEnabled,
    });
    return Future.value(Empty());
  }
}
