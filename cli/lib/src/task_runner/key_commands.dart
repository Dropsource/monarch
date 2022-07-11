import 'dart:async';

import 'package:meta/meta.dart';
import 'package:monarch_io_utils/utils.dart';
import 'package:monarch_utils/log.dart';

import 'process_task.dart';
import 'reloaders.dart';
import '../utils/standard_output.dart' show StandardOutput;
import 'grpc.dart';
import 'task_count_heartbeat.dart';

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
      var reloader = HotReloader(controllerGrpcClient, stdout_);
      await reloader.reload(heartbeat);
    });
  }

  final ControllerGrpcClient controllerGrpcClient;
  final StandardOutput stdout_;
  final bool isDefault;

  HotReloadKeyCommand({
    required this.controllerGrpcClient,
    required this.stdout_,
    required this.isDefault,
  });
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
      var reloader = HotRestarter(bundleTask, controllerGrpcClient);
      await reloader.reload(heartbeat);
    });
  }

  final ProcessTask bundleTask;
  final ControllerGrpcClient controllerGrpcClient;
  final StandardOutput stdout_;
  final bool isDefault;

  HotRestartKeyCommand({
    required this.bundleTask,
    required this.controllerGrpcClient,
    required this.stdout_,
    required this.isDefault,
  });
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
  void run() {}

  QuitKeyCommand();
}

class GenerateAndHotReloadKeyCommand extends KeyCommand {
  @override
  String get description => 'Regenerate stories and hot reload.';

  @override
  String get key => 'r';

  final StandardOutput stdout_;
  final ProcessTask generateTask;
  final ControllerGrpcClient controllerGrpcClient;

  GenerateAndHotReloadKeyCommand({
    required this.stdout_,
    required this.generateTask,
    required this.controllerGrpcClient,
  });

  @override
  void run() {
    running(() async {
      var heartbeat = SimpleHeartbeat(kReloadingStories);
      heartbeat.start();

      await generateTask.run();
      await generateTask.done();

      var reloader = HotReloader(controllerGrpcClient, stdout_);
      await reloader.reload(heartbeat);
    });
  }
}

class GenerateAndHotRestartKeyCommand extends KeyCommand {
  @override
  String get description => 'Regenerate stories and hot restart.';

  @override
  String get key => 'R';

  final ProcessTask generateTask;
  final ProcessTask bundleTask;
  final ControllerGrpcClient controllerGrpcClient;

  GenerateAndHotRestartKeyCommand({
    required this.generateTask,
    required this.bundleTask,
    required this.controllerGrpcClient,
  });

  @override
  void run() {
    running(() async {
      var heartbeat = SimpleHeartbeat(kReloadingStoriesHotRestart);
      heartbeat.start();

      await generateTask.run();
      await generateTask.done();

      var reloader = HotRestarter(bundleTask, controllerGrpcClient);
      await reloader.reload(heartbeat);
    });
  }
}
