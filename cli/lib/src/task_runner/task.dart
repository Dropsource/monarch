enum TaskStatus { created, running, ready, terminated, done, failed }

abstract class Task {
  TaskStatus get status;

  /// Runs the task and returns a future that completes when the task is running.
  Future run();

  /// Returns a future that completes when the task is done or failed.
  /// It does not throw if it failed. Use [throwIfFailed] if needed.
  Future done();

  /// Throws if the task failed
  void throwIfFailed();

  /// Terminates a running task.
  void terminate();
}

abstract class ReadyTask extends Task {
  /// Returns a future that completes when the task is ready.
  Future ready();
}
