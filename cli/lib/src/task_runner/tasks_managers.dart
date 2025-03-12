import 'package:monarch_cli/src/task_runner/task.dart';
import 'package:monarch_utils/log.dart';

import 'preview_api.dart';
import 'reloaders.dart';
import 'process_task.dart';
import '../utils/standard_output.dart' show StandardOutput;
import 'task_count_heartbeat.dart';

abstract class TasksManager with Log {
  final ProcessParentReadyTask regenTask;
  TasksManager(this.regenTask);

  String get reloadingStoriesMessage;
  bool get isRunning;

  bool _isReloading = false;
  bool _needsReload = false;

  void manage() {
    var heartbeat = SimpleHeartbeat(reloadingStoriesMessage);
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
            _manageReload(heartbeat);
          }
          break;

        case ChildTaskStatus.failed:
          if (heartbeat.isActive) {
            heartbeat.completeError();
          }
          break;

      }
    });
  }

  void _manageReload(Heartbeat heartbeat) async {
    _needsReload = false;

    _isReloading = true;
    await reload(heartbeat);
    _isReloading = false;

    if (_needsReload) {
      if (!heartbeat.isActive) {
        heartbeat.start();
      }
      _manageReload(heartbeat);
    }
  }

  Future<void> reload(Heartbeat heartbeat);
}

class RegenAndHotReload extends TasksManager {
  final StandardOutput stdout_;
  final PreviewApi previewApi;

  RegenAndHotReload({
    required this.stdout_,
    required ProcessParentReadyTask regenTask,
    required this.previewApi,
  }) : super(regenTask);

  @override
  bool get isRunning =>
      regenTask.childTaskStatus == ChildTaskStatus.running || _isReloading;

  @override
  String get reloadingStoriesMessage => kReloadingStories;

  @override
  Future<void> reload(Heartbeat heartbeat) async {
    var reloader = HotReloader(previewApi, stdout_);
    await reloader.reload(heartbeat);
  }
}

class RegenRebundleAndHotRestart extends TasksManager {
  final ProcessTask buildPreviewBundleTask;
  final PreviewApi previewApi;
  final StandardOutput stdout_;

  RegenRebundleAndHotRestart({
    required ProcessParentReadyTask regenTask,
    required this.buildPreviewBundleTask,
    required this.previewApi,
    required this.stdout_,
  }) : super(regenTask);

  @override
  bool get isRunning =>
      regenTask.childTaskStatus == ChildTaskStatus.running ||
      buildPreviewBundleTask.status == TaskStatus.running ||
      _isReloading;

  @override
  String get reloadingStoriesMessage => kReloadingStoriesHotRestart;

  @override
  Future<void> reload(Heartbeat heartbeat) async {
    var reloader = HotRestarter(buildPreviewBundleTask, previewApi, stdout_);
    await reloader.reload(heartbeat);
  }
}
