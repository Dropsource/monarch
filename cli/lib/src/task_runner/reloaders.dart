import 'package:monarch_utils/log.dart';

import '../utils/standard_output.dart';
import 'preview_api.dart';
import 'process_task.dart';
import 'task.dart';

const kTryAgainAfterFixing = 'Try again after fixing the above error(s).';
const kReloadingStories = 'Reloading stories';
const kReloadingStoriesHotRestart = 'Reloading stories (with hot restart)';

abstract class Reloader with Log {
  Future<void> reload(Heartbeat heartbeat);
}

class HotReloader extends Reloader {
  final PreviewApi previewApi;
  final StandardOutput stdout_;
  HotReloader(
    this.previewApi,
    this.stdout_,
  );

  /// Calls hot-reload on the controller grpc server.
  /// It checks if the hot-reload request was successful.
  /// It does not regen or rebundle.
  @override
  Future<void> reload(Heartbeat heartbeat) async {
    if (await previewApi.isClientInitialized()) {
      log.fine('Sending hotReload request to controller grpc client');
      var isSuccessful = await previewApi.hotReload();
      heartbeat.complete();
      if (!isSuccessful) {
        stdout_.writeln(kTryAgainAfterFixing);
      }
    } else {
      log.warning('Unable to hot reload. The preview_api is not available.');
    }
  }
}

class HotRestarter extends Reloader {
  final PreviewApi previewApi;
  final ProcessTask bundleTask;

  HotRestarter(this.bundleTask, this.previewApi);

  /// It restarts the Monarch Preview. Restarts the Preview by closing the existing
  /// Preview window and opening a new one.
  ///
  /// We don't use the vm service restart functionality because it also restarts the
  /// controller window.
  ///
  /// Restart sequence:
  ///
  /// - Build the preview bundle
  /// - Request the controller to restart the preview window
  /// - The controller in turn sends a message to the window manager to relaunch the preview window
  @override
  Future<void> reload(Heartbeat heartbeat) async {
    await bundleTask.run();
    await bundleTask.done();

    if (bundleTask.status == TaskStatus.failed) {
      heartbeat.completeError();
      return;
    }

    if (await previewApi.isClientInitialized()) {
      log.fine('Sending restartPreview request to controller grpc client');
      await previewApi.restartPreview();
    } else {
      log.warning('Unable to hot restart. The preview_api is not available.');
    }
    heartbeat.complete();
  }
}
