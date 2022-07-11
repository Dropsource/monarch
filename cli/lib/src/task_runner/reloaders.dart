import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import '../utils/standard_output.dart';
import 'grpc.dart';
import 'process_task.dart';
import 'task.dart';

const kTryAgainAfterFixing = 'Try again after fixing the above error(s).';
const kReloadingStories = 'Reloading stories';
const kReloadingStoriesHotRestart = 'Reloading stories (with hot restart)';

abstract class Reloader with Log {
  Future<void> reload(Heartbeat heartbeat);
}

class HotReloader extends Reloader {
  final ControllerGrpcClient controllerGrpcClient;
  final StandardOutput stdout_;
  HotReloader(
    this.controllerGrpcClient,
    this.stdout_,
  );

  /// Calls hot-reload on the controller grpc server.
  /// It checks if the hot-reload request was successful.
  /// It does not regen or rebundle.
  @override
  Future<void> reload(Heartbeat heartbeat) async {
    if (controllerGrpcClient.isClientInitialized) {
      log.fine('Sending hotReload request to controller grpc client');
      var response = await controllerGrpcClient.client!.hotReload(Empty());
      heartbeat.complete();
      if (!response.isSuccessful) {
        stdout_.writeln(kTryAgainAfterFixing);
      }
    } else {
      log.warning(
          'Unable to hot reload. The controller grpc client is not initialized.');
    }
  }
}

class HotRestarter extends Reloader {
  final ControllerGrpcClient controllerGrpcClient;
  final ProcessTask bundleTask;

  HotRestarter(this.bundleTask, this.controllerGrpcClient);

  /// Builds the preview bundle, then calls restart-preview on the controller
  /// grpc server.
  /// It does not regen.
  @override
  Future<void> reload(Heartbeat heartbeat) async {
    await bundleTask.run();
    await bundleTask.done();
    if (bundleTask.status == TaskStatus.failed) {
      heartbeat.completeError();
    } else {
      requestRestartPreview();
      heartbeat.complete();
    }
  }

  Future<void> requestRestartPreview() async {
    if (controllerGrpcClient.isClientInitialized) {
      log.fine('Sending restartPreview request to controller grpc client');
      await controllerGrpcClient.client!.restartPreview(Empty());
    } else {
      log.warning(
          'Unable to hot restart. The controller grpc client is not initialized.');
    }
  }
}
