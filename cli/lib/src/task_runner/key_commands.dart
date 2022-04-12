import 'dart:async';

import 'package:meta/meta.dart';
import 'package:monarch_io_utils/utils.dart';
import 'package:monarch_utils/log.dart';

import 'process_task.dart';
import 'reload.dart';
import '../utils/standard_output.dart' show StandardOutput;

abstract class KeyCommand {
  String get key;

  String get description;

  void run();

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  @protected
  void running(Future<void> Function() runFn) async {
    _isRunning = true;
    await runFn();
    _isRunning = false;
  }
}

class HotReloadKeyCommand extends KeyCommand {
  @override
  String get description => isDefault ? 'Hot reload (default).' : 'Hot reload.';

  @override
  String get key => 'r';

  @override
  void run() {
    running(() async {
      var heartbeat = Heartbeat(kReloadingStories, stdout_.writeln);
      heartbeat.start();
      var reloader = HotReloader(reloadTask, stdout_);
      await reloader.reload(heartbeat);
    });
  }

  final ProcessParentReadyTask reloadTask;
  final StandardOutput stdout_;
  final bool isDefault;

  HotReloadKeyCommand(
      {required this.reloadTask,
      required this.stdout_,
      required this.isDefault});
}

class HotRestartKeyCommand extends KeyCommand {
  @override
  String get description =>
      isDefault ? 'Hot restart (default).' : 'Hot restart.';

  @override
  String get key => 'R';

  @override
  void run() {
    running(() async {
      var heartbeat = Heartbeat(kReloadingStoriesHotRestart, stdout_.writeln);
      heartbeat.start();
      var reloader = HotRestarter(reloadTask, stdout_);
      await reloader.reload(heartbeat);
    });
  }

  final ProcessParentReadyTask reloadTask;
  final StandardOutput stdout_;
  final bool isDefault;

  HotRestartKeyCommand(
      {required this.reloadTask,
      required this.stdout_,
      required this.isDefault});
}

class HelpKeyCommand extends KeyCommand {
  @override
  String get description => 'Show this list of commands.';

  @override
  String get key => 'h';

  @override
  void run() => _printHelp();

  void _printHelp() {
    stdout_.writeln();
    stdout_.writeln('Monarch key commands:');
    for (var command in commands) {
      stdout_.writeln('${command.key} ${command.description}');
    }
  }

  final List<KeyCommand> commands;
  final StandardOutput stdout_;

  HelpKeyCommand(this.commands, this.stdout_);
}

class QuitKeyCommand extends KeyCommand {
  @override
  String get description => 'Quit.';

  @override
  String get key => valueForPlatform(macos: '⌃C', windows: 'CTRL+C');

  @override
  void run() => null;

  QuitKeyCommand();
}

abstract class Reloader {
  final ProcessParentReadyTask reloadTask;
  final StandardOutput stdout_;
  Reloader(this.reloadTask, this.stdout_);

  Future<void> reload(Heartbeat heartbeat) async {
    var reloadCompleter = Completer();
    var subscription =
        reloadTask.childTaskStatusStream.listen((childTaskStatus) {
      switch (childTaskStatus) {
        case ChildTaskStatus.running:
          break;

        case ChildTaskStatus.done:
        case ChildTaskStatus.failed:
          if (heartbeat.isActive) {
            heartbeat.complete();
          }
          if (!reloadCompleter.isCompleted) {
            reloadCompleter.complete();
          }
          if (childTaskStatus == ChildTaskStatus.failed) {
            stdout_.writeln(kTryAgainAfterFixing);
          }

          break;

        default:
      }
    });

    requestReload();
    await reloadCompleter.future;
    // wait a little bit in case reload emits 'failed' after 'done'
    await Future.delayed(Duration(milliseconds: 50));
    await subscription.cancel();
  }

  void requestReload();
}

class HotReloader extends Reloader {
  HotReloader(ProcessParentReadyTask reloadTask, StandardOutput stdout_)
      : super(reloadTask, stdout_);
  @override
  void requestReload() => requestHotReload(reloadTask);
}

class HotRestarter extends Reloader {
  HotRestarter(ProcessParentReadyTask reloadTask, StandardOutput stdout_)
      : super(reloadTask, stdout_);
  @override
  void requestReload() => requestHotRestart(reloadTask);
}

abstract class GenerateAndReloadKeyCommand extends KeyCommand {
  @override
  void run() {
    running(() async {
      var heartbeat = Heartbeat(heartbeatMessage, stdout_.writeln);
      heartbeat.start();

      await generateTask.run();
      await generateTask.done();

      await reloader.reload(heartbeat);
    });
  }

  String get heartbeatMessage;
  Reloader get reloader;

  final StandardOutput stdout_;

  /// The "generate-meta-stories" task.
  final ProcessTask generateTask;

  /// The "attach-to-hot-restart" task.
  final ProcessParentReadyTask reloadTask;

  GenerateAndReloadKeyCommand(
      {required this.stdout_,
      required this.generateTask,
      required this.reloadTask});
}

class GenerateAndHotReloadKeyCommand extends GenerateAndReloadKeyCommand {
  @override
  String get description => 'Regenerate stories and hot reload.';

  @override
  String get heartbeatMessage => kReloadingStories;

  @override
  String get key => 'r';

  @override
  Reloader get reloader => HotReloader(reloadTask, stdout_);

  GenerateAndHotReloadKeyCommand(
      {required StandardOutput stdout_,
      required ProcessTask generateTask,
      required ProcessParentReadyTask reloadTask})
      : super(
            stdout_: stdout_,
            generateTask: generateTask,
            reloadTask: reloadTask);
}

class GenerateAndHotRestartKeyCommand extends GenerateAndReloadKeyCommand {
  @override
  String get description => 'Regenerate stories and hot restart.';

  @override
  String get heartbeatMessage => kReloadingStoriesHotRestart;

  @override
  String get key => 'R';

  @override
  Reloader get reloader => HotRestarter(reloadTask, stdout_);

  GenerateAndHotRestartKeyCommand(
      {required StandardOutput stdout_,
      required ProcessTask generateTask,
      required ProcessParentReadyTask reloadTask})
      : super(
            stdout_: stdout_,
            generateTask: generateTask,
            reloadTask: reloadTask);
}
