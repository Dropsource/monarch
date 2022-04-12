import 'process_task.dart';

const kTryAgainAfterFixing = 'Try again after fixing the above error(s).';
const kReloadingStories = 'Reloading stories';
const kReloadingStoriesHotRestart = 'Reloading stories (with hot restart)';

void requestHotReload(ProcessTask task) {
  task.process!.stdin.write('r');
}

void requestHotRestart(ProcessTask task) {
  task.process!.stdin.write('R');
}
