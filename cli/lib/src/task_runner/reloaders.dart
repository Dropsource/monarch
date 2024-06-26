import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:monarch_utils/log.dart';

import '../utils/standard_output.dart';
import 'preview_api.dart';
import 'process_task.dart';
import 'task.dart';
import 'reload_crash.dart' as reload_crash;

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

  /// Calls hot-reload on the preview_api.
  /// It checks if the hot-reload request was successful.
  /// It does not regen or rebundle.
  @override
  Future<void> reload(Heartbeat heartbeat) async {
    if (await previewApi.isAvailable()) {
      log.fine('Sending hotReload request to preview_api');
      try {
        var isSuccessful = await previewApi.hotReload();
        heartbeat.complete();
        if (!isSuccessful) {
          stdout_.writeln(kTryAgainAfterFixing);
        }
      } on GrpcError catch (e, s) {
        reload_crash.hadHotReloadGrpcError = true;
        log.severe('GrpcError during call to previewApi.hotReload', e, s);
        heartbeat.completeError();
      }
    } else {
      log.warning('Unable to hot reload. The preview_api is not available.');
      heartbeat.completeError();
    }
  }
}

class HotRestarter extends Reloader {
  final PreviewApi previewApi;
  final ProcessTask bundleTask;
  final StandardOutput stdout_;

  HotRestarter(this.bundleTask, this.previewApi, this.stdout_);

  /// It restarts the Monarch Preview. Restarts the Preview by closing the existing
  /// Preview window and opening a new one.
  ///
  /// We don't use the vm service restart functionality because it restarts all
  /// the isolates, not just the preview window isolate. On macOS, a vm service
  /// restart would restart the controller, preview and preview api.
  ///
  /// Restart sequence:
  ///
  /// - Build the preview bundle
  /// - Request the preview api to restart the preview window
  /// - The preview api, in turn, sends a message to the platform window manager to
  ///   relaunch the preview window
  @override
  Future<void> reload(Heartbeat heartbeat) async {
    if (!await previewApi.isAvailable()) {
      log.warning('Unable to hot restart. The preview_api is not available.');
      heartbeat.completeError();
      return;
    }

    if (Platform.isWindows) {
      // On Windows, we have to close the preview window before we re-bundle.
      // Otherwise, copying the new bundle will fail.
      // This message is to inform the user that the preview window
      // will re-open.
      stdout_.writeln('Preview window will re-open.');
    }

    log.info('Calling previewApi.willRestartPreview');
    await previewApi.willRestartPreview();

    log.info('Bundling');
    await bundleTask.run();
    await bundleTask.done();


    if (bundleTask.status == TaskStatus.failed) {
      heartbeat.completeError();
      return;
    }

    log.info('Calling previewApi.restartPreview');
    await previewApi.restartPreview();

    heartbeat.complete();
  }
}
