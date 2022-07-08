import 'package:monarch_cli/src/task_runner/task.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import 'grpc.dart';
import 'reload.dart';
import 'process_task.dart';
import '../utils/standard_output.dart' show StandardOutput;
import 'task_count_heartbeat.dart';

abstract class TasksManager with Log {
  void manage();
  bool get isRunning;
}

class RegenAndHotReload extends TasksManager {
  final StandardOutput stdout_;
  final ProcessParentReadyTask regenTask;
  final ControllerGrpcClient controllerGrpcClient;

  RegenAndHotReload({
    required this.stdout_,
    required this.regenTask,
    required this.controllerGrpcClient,
  });

  bool _isReloading = false;
  bool _needsReload = false;

  @override
  bool get isRunning =>
      regenTask.childTaskStatus == ChildTaskStatus.running || _isReloading;

  final heartbeat = SimpleHeartbeat(kReloadingStories);

  @override
  void manage() {
    regenTask.childTaskStatusStream.listen((childTaskStatus) {
      switch (childTaskStatus) {
        case ChildTaskStatus.running:
          if (!heartbeat.isActive) {
            heartbeat.start();
          }
          break;

        case ChildTaskStatus.done:
          _needsReload = true;
          if (!_isReloading) {
            reload();
          }
          break;

        case ChildTaskStatus.failed:
          if (heartbeat.isActive) {
            heartbeat.completeError();
          }
          break;

        default:
      }
    });
  }

  void reload() async {
    _needsReload = false;
    if (controllerGrpcClient.isClientInitialized) {
      log.fine('Sending hotReload request to controller grpc client');
      _isReloading = true;
      var response = await controllerGrpcClient.client!.hotReload(Empty());
      _isReloading = false;
      heartbeat.complete();
      if (!response.isSuccessful) {
        stdout_.writeln(kTryAgainAfterFixing);
      }
      if (_needsReload) {
        reload();
      }
    } else {
      log.warning(
          'Unable to hot reload. The controller grpc client is not initialized.');
    }
  }
}

class RegenRebundleAndHotRestart extends TasksManager {
  final ProcessParentReadyTask regenTask;
  final ProcessTask buildPreviewBundleTask;
  final ControllerGrpcClient controllerGrpcClient;

  RegenRebundleAndHotRestart({
    required this.regenTask,
    required this.buildPreviewBundleTask,
    required this.controllerGrpcClient,
  });

  @override
  bool get isRunning =>
      regenTask.childTaskStatus == ChildTaskStatus.running ||
      buildPreviewBundleTask.status == TaskStatus.running;

  final heartbeat =
      TaskCountHeartbeat(kReloadingStoriesHotRestart, taskCount: 2);

  @override
  void manage() {
    regenTask.childTaskStatusStream.listen((childTaskStatus) {
      switch (childTaskStatus) {
        case ChildTaskStatus.running:
          if (!heartbeat.isActive) {
            heartbeat.completedTaskCount = 0;
            heartbeat.start();
          }
          break;

        case ChildTaskStatus.done:
          heartbeat.completedTaskCount = 1;
          rebundle();
          break;

        case ChildTaskStatus.failed:
          if (heartbeat.isActive) {
            heartbeat.completeError();
          }
          break;

        default:
      }
    });
  }

  void rebundle() async {
    await buildPreviewBundleTask.run();
    await buildPreviewBundleTask.done();
    if (buildPreviewBundleTask.status == TaskStatus.failed) {
      heartbeat.completeError();
    } else {
      requestRestartPreview();
      heartbeat.complete();
    }
  }

  void requestRestartPreview() async {
    if (controllerGrpcClient.isClientInitialized) {
      log.fine('Sending restartPreview request to controller grpc client');
      controllerGrpcClient.client!.restartPreview(Empty());
    } else {
      log.warning(
          'Unable to hot restart. The controller grpc client is not initialized.');
    }
  }
}
