import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import '../analytics/analytics.dart';
import 'discovery_api_service.dart';
import 'preview_notifications_api_service.dart';
import 'task_runner.dart';

final _logger = Logger('CliGrpc');

Future<int> setUpDiscoveryApiServer() async {
  var server = Server([DiscoveryApiService()]);
  await server.serve(port: 0);
  var discoveryApiPort = server.port!;
  _logger.info(
      'discovery_api grpc server (discovery api service) started on port $discoveryApiPort');
  return discoveryApiPort;
}

Future<void> setUpNotificationsApiServer(
    int discoveryServerPort, TaskRunner taskRunner, Analytics analytics) async {
  _logger.info('Will use discovery server at port $discoveryServerPort');
  var channel = constructClientChannel(discoveryServerPort);
  var discoveryClient = MonarchDiscoveryApiClient(channel);

  var server = Server([PreviewNotificationsApiService(taskRunner, analytics)]);
  await server.serve(port: 0);
  var previewNotificationsApiPort = server.port!;
  _logger.info(
      'preview_notifications_api grpc server (preview notifications api service) started on port $previewNotificationsApiPort');
  discoveryClient.registerPreviewNotificationsApi(
      ServerInfo(port: previewNotificationsApiPort));
}
