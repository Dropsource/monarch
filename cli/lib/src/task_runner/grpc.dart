import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import '../analytics/analytics.dart';
import 'discovery_api_service.dart';
import 'preview_notifications_api_service.dart';
import 'task_runner.dart';

class Grpc with Log {
  Server? _discoveryApiServer;
  Server? _previewNotificationsApiServer;

  int get discoveryApiServerPort => _discoveryApiServer!.port!;
  int get previewNotificationsApiServerPort =>
      _previewNotificationsApiServer!.port!;

  ClientChannel? _discoveryApiClientChannel;

  Future<void> setUpDiscoveryApiServer() async {
    _discoveryApiServer = Server([DiscoveryApiService()]);
    await _discoveryApiServer!.serve(port: 0);
    log.info(
        'discovery_api grpc server (discovery api service) started on port $discoveryApiServerPort');
  }

  MonarchDiscoveryApiClient getDiscoveryApiClient() {
    log.info('Will use discovery server at port $discoveryApiServerPort');
    _discoveryApiClientChannel = constructClientChannel(discoveryApiServerPort);
    return MonarchDiscoveryApiClient(_discoveryApiClientChannel!);
  }

  Future<void> setUpNotificationsApiServer(
      MonarchDiscoveryApiClient discoveryApiClient,
      TaskRunner taskRunner,
      Analytics analytics) async {
    _previewNotificationsApiServer =
        Server([PreviewNotificationsApiService(taskRunner, analytics)]);
    await _previewNotificationsApiServer!.serve(port: 0);
    log.info(
        'preview_notifications_api grpc server (preview notifications api service) started on port $previewNotificationsApiServerPort');

    await discoveryApiClient.registerPreviewNotificationsApi(
        ServerInfo(port: previewNotificationsApiServerPort));
  }

  Future<void> shutdownServers() async {
    var done = <Future<void>>[];
    if (_discoveryApiServer != null) {
      done.add(_discoveryApiServer!.shutdown());
    }
    if (_previewNotificationsApiServer != null) {
      done.add(_previewNotificationsApiServer!.shutdown());
    }
    await Future.wait(done);
    _discoveryApiServer = null;
    _previewNotificationsApiServer = null;
  }
}
