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
