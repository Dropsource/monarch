import 'dart:io';

import 'package:monarch_utils/log.dart';

import 'process_task.dart';
import '../utils/standard_output.dart';

class Terminator with Log {
  final List<ProcessTask?> tasks;

  Terminator(this.tasks);

  void terminateTasks() {
    stdout_default.writeln('\nTerminating running tasks...');
    tasks.forEach(_terminateTask);
    _verifyTermination();
    stdout_default.writeln('Done');
  }

  void _terminateTask(ProcessTask? processTask) {
    if (_hasTaskRun(processTask)) {
      if (processTask!.isInFinalState) {
        log.fine(
            'Task is already in final state, will not terminate: ${_taskName(processTask)}');
      } else {
        log.fine('Terminating task ${processTask.taskName}');
        processTask.terminate();
      }
    } else {
      log.fine(
          'Tasks has not run, will not terminate: ${_taskName(processTask)}');
    }
  }

  String _taskName(ProcessTask? processTask) {
    if (processTask == null) {
      return 'task-not-set';
    } else {
      return processTask.taskName;
    }
  }

  bool _hasTaskRun(ProcessTask? processTask) {
    return processTask != null && processTask.process != null;
  }

  void _verifyTermination() {
    for (var task in tasks) {
      if (_hasTaskRun(task) && !task!.isInFinalState) {
        log.warning('Expected task to be terminated: ${task.taskName}');
      }
    }
  }
}

class WindowsTerminator {
  /// On Windows, it kills tasks by window title using the command:
  /// taskkill /F /FI "WindowTitle eq [windowTitle]" /T
  ///
  /// Example:
  /// taskkill /F /FI "WindowTitle eq my_project - Monarch" /T
  ///
  /// Due to a bug, Dart on Windows is not able to kill child processes thus the [Terminator]
  /// class doest not terminate all the processes Monarch starts.
  ///
  /// See Github issues:
  /// - https://github.com/dart-lang/sdk/issues/49234
  /// - https://github.com/flutter/flutter/issues/98435
  /// - https://github.com/dart-lang/sdk/issues/22470
  ///
  /// This function kills most of the dart processes that Monarch starts.
  /// However, there are other processes started by monarch.exe (aka the Monarch CLI) which
  /// are being left orphan.
  ///
  /// Once the issues above are fixed, the [Terminator] class should work as
  /// expected and we won't need this function anymore.
  static void killTasksByWindowTitle(String windowTitle) {
    var log_ = Logger('WindowsTerminator');
    if (!Platform.isWindows) {
      log_.warning(
          'The killTasksByWindowTitle function should only be called on the Windows platform');
    }
    log_.fine('Terminating tasks whose window title is: $windowTitle');
    var result = Process.runSync(
        'taskkill', ['/F', '/FI', 'WindowTitle eq $windowTitle', '/T'],
        runInShell: true);
    log_.fine(result.stdout);
    log_.fine(result.stderr);
  }
}
