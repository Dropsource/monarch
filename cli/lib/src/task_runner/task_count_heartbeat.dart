import 'package:monarch_utils/log.dart';
import '../utils/standard_output.dart';

typedef WriteLineFunction = void Function(String);

class TaskCountHeartbeat extends Heartbeat {
  final int taskCount;
  // late final WriteLineFunction writeln;
  int completedTaskCount = 0;

  TaskCountHeartbeat(String message,
      {required this.taskCount, WriteLineFunction? writeln_})
      : assert(taskCount > 0),
        super(
            message,
            (String line) => writeln_ == null
                ? stdout_default.writeln(line)
                : writeln_(line));

  @override
  void checkProgress(_) {
    writeln(
        '${stopwatch!..stop()} elapsed, $completedTaskCount/$taskCount tasks completed');
  }
}
