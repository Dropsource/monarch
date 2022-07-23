import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import '../utils/standard_output.dart';
import 'attach_task.dart';
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
  final AttachTask attachTask;

  HotRestarter(this.bundleTask, this.attachTask, this.controllerGrpcClient);

  /// It restarts the Monarch Preview. Restarts the Preview by closing the existing
  /// Preview window and opening a new one.
  /// 
  /// We don't use the vm service restart functionality because it also restarts the 
  /// controller window.
  /// 
  /// Restart sequence:
  /// 
  /// - Build the preview bundle
  /// - Kill the current attach process
  /// - Request the controller to restart the preview window
  /// - The controller in turn sends a message to the window manager to relaunch the preview window
  /// - The new preview runtime will call the cli grpc service with the new debug uri
  /// - The cli grpc service will then re-attach
  @override
  Future<void> reload(Heartbeat heartbeat) async {
    await bundleTask.run();
    await bundleTask.done();

    if (bundleTask.status == TaskStatus.failed) {
      heartbeat.completeError();
      return;
    } 

    if (controllerGrpcClient.isClientInitialized) {
      attachTask.kill();
      log.fine('Sending restartPreview request to controller grpc client');
      await controllerGrpcClient.client!.restartPreview(Empty());
    } else {
      log.warning(
          'Unable to hot restart. The controller grpc client is not initialized.');
    }
    heartbeat.complete();
  }
}
