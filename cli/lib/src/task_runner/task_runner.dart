import 'dart:async';
import 'dart:io';

import 'package:monarch_cli/src/task_runner/preview_api.dart';
import 'package:monarch_cli/src/utils/standard_input.dart';
import 'package:path/path.dart' as p;
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:pub_semver/pub_semver.dart' as pub;

import '../analytics/analytics.dart';
import '../config/monarch_binaries.dart';
import '../config/project_config.dart';
import '../utils/cli_exit_code.dart';
import '../utils/standard_output.dart';
import 'attach_task.dart';
import 'monarch_app_stdout.dart';
import 'monarch_app_stderr.dart';
import 'task.dart';
import 'task_runner_exit_codes.dart';
import 'process_task.dart';
import 'task_count_heartbeat.dart';
import 'task_names.dart';
import 'terminator.dart';
import 'key_commands.dart';
import 'tasks_managers.dart';

enum ReloadOption { hotReload, hotRestart, manual }

class TaskRunner extends LongRunningCli<CliExitCode> with Log {
  final Directory projectDirectory;
  final TaskRunnerProjectConfig config;
  final MonarchBinaries monarchBinaries;
  final bool isVerbose;
  final bool isDeleteConflictingOutputs;
  final bool noSoundNullSafety;
  final ReloadOption reloadOption;
  final Analytics analytics;
  final int discoveryServerPort;
  final PreviewApi previewApi;

  String get generatedMainFilePath => p.join('.dart_tool', 'build', 'generated',
      config.pubspecProjectName, 'lib', 'main_monarch.g.dart');

  String get dotMonarch => '.monarch';
  String get flutterAssetsDirectoryPath => p.join(dotMonarch, 'flutter_assets');

  bool get isReloadAutomatic => reloadOption != ReloadOption.manual;

  bool _isTerminating = false;

  TaskRunner({
    required this.projectDirectory,
    required this.config,
    required this.monarchBinaries,
    required this.isVerbose,
    required this.isDeleteConflictingOutputs,
    required this.noSoundNullSafety,
    required this.reloadOption,
    required this.analytics,
    required this.discoveryServerPort,
    required this.previewApi,
  });

  /*
  /// ### The Monarch Preview
  /// 
  /// The Monarch Preview is composed of:
  /// - meta source files: meta stories, meta themes, meta localizations
  /// - main file
  /// - monarch package
  /// 
  /// The meta source files and main file are generated from the project source
  /// files. The monarch package is imported by the generated main file.
  */

  /// Generates the source files of the Monarch Preview. This process
  /// performs a single generation.
  ///
  /// It uses `flutter pub run build_runner build`.
  ProcessTask? _generateStoriesTask;

  /// Builds the Monarch Preview into a bundle, i.e. it builds the Flutter
  /// assets directory of the Monarch Preview.
  ///
  /// Builds the .monarch/flutter_assets directory using the generated source
  /// files of the Monarch Preview.
  ///
  /// The flutter_assets directory contains the snapshots and assets for the
  /// Monarch Preview.
  ///
  /// It uses `flutter build bundle`.
  ProcessTask? _buildPreviewBundleTask;

  /// Launches the Monarch desktop app for the current platform and Flutter SDK.
  /// The desktop app launches the Monarch Controller and Preview.
  ProcessReadyTask? _runMonarchAppTask;

  /// Similar to [_runMonarchAppTask] but it only launches the Preview.
  ProcessReadyTask? _runPreviewAppTask;

  /// Similar to [_runMonarchAppTask] but it only launches the Controller.
  ProcessReadyTask? _runControllerAppTask;

  /// Attaches to the running Monarch Preview. This process allows us to
  /// hot reload.
  ///
  /// We don't reload the user source files, we reload the generated source files,
  /// thus the hot reload occur after a re-generation has completed.
  ///
  /// It uses `flutter attach`.
  AttachTask? _attachToReloadTask;
  AttachTask? get attachTask => _attachToReloadTask;

  /// Watches the user project for source file changes. When it detects a change
  /// it performs a re-generation.
  ///
  /// It uses `flutter pub run build_runner watch`.
  ProcessParentReadyTask? _watchToRegenTask;

  /// Manages the child tasks of [_watchToRegenTask] and [_attachToReloadTask].
  TasksManager? _regenAndReloadManager;

  StreamSubscription? _keystrokeSubscription;

  bool _isStarting = false;
  bool get isStarting => _isStarting;

  @override
  void didRun() async {
    _isStarting = true;
    await _runTasks();
    _isStarting = false;
  }

  @override
  CliExitCode get userTerminatedExitCode => CliExitCodes.userTerminated;

  @override
  Future<void> willTerminate() async {
    _isTerminating = true;
    stdin_default.singleCharMode = false;
    _keystrokeSubscription?.cancel();
    _terminateTasks();
  }

  Future<void> _runTasks() async {
    _createInitialTasks();
    await _runInitialTasks();

    if (hasExited) {
      return;
    }

    await _createLongRunningTasks();
    await _runLongRunningTasks();
  }

  void _terminateTasks() {
    if (Platform.isWindows) {
      WindowsTerminator.killTasksByWindowTitle(
          '${config.pubspecProjectName} - Monarch');
    }

    previewApi.terminatePreview();

    final tasks = [
      _generateStoriesTask,
      _buildPreviewBundleTask,
      _runMonarchAppTask,
      _runPreviewAppTask,
      _runControllerAppTask,
      _attachToReloadTask?.task,
      _watchToRegenTask
    ];

    var terminator = Terminator(tasks);
    terminator.terminateTasks();
  }

  void _createInitialTasks() {
    _generateStoriesTask = ProcessTask(
        taskName: TaskNames.generateMetaStories,
        executable: config.flutterExecutablePath,
        arguments: [
          'pub',
          'run',
          'build_runner',
          'build',
          if (isVerbose) '--verbose',
          if (isDeleteConflictingOutputs) '--delete-conflicting-outputs',
          if (noSoundNullSafety) '--define',
          if (noSoundNullSafety)
            'monarch:main_builder=no-sound-null-safety=true'
        ],
        workingDirectory: projectDirectory.path,
        analytics: analytics,
        logLevelRegex: RegExp(r'^\[(\w+)\]'));

    _buildPreviewBundleTask = ProcessTask(
        taskName: TaskNames.buildPreviewBundle,
        executable: config.flutterExecutablePath,
        arguments: [
          'build',
          'bundle',
          '-t',
          generatedMainFilePath,
          '--debug',
          '--target-platform',
          valueForPlatform(
              macos: _getDarwinTargetPlatform(), windows: 'windows-x64'),
          '--asset-dir',
          flutterAssetsDirectoryPath,
          if (isVerbose) '--verbose'
        ],
        workingDirectory: projectDirectory.path,
        analytics: analytics);
  }

  String _getDarwinTargetPlatform() {
    if (pub.Version(2, 3, 0, pre: '1.0.pre') <=
        pub.Version.parse(config.flutterSdkId.version)) {
      return 'darwin';
    } else {
      return 'darwin-x64';
    }
  }

  Future _runInitialTasks() async {
    final prepping = TaskCountHeartbeat('Preparing stories', taskCount: 2)
      ..start();

    await _generateStoriesTask!.run();
    await _generateStoriesTask!.done();
    _checkInitialTaskFinalStatus(
        _generateStoriesTask!.status,
        '${prepping.message} (code generation) failed. Exiting.',
        TaskRunnerExitCodes.generateStoriesFailed,
        TaskRunnerExitCodes.generateStoriesTerminated);

    if (hasExited) {
      return;
    }

    prepping.completedTaskCount++;

    await _buildPreviewBundleTask!.run();
    await _buildPreviewBundleTask!.done();
    _checkInitialTaskFinalStatus(
        _buildPreviewBundleTask!.status,
        '${prepping.message} (building bundle) failed. Exiting.',
        TaskRunnerExitCodes.buildPreviewBundleFailed,
        TaskRunnerExitCodes.buildPreviewBundleTerminated);

    if (hasExited) {
      return;
    }

    await _copyIcuDataFileOnWindows();

    if (hasExited) {
      return;
    }

    prepping.complete();
  }

  Future<void> _copyIcuDataFileOnWindows() async {
    if (Platform.isWindows) {
      try {
        final icuDataFile = monarchBinaries.icuDataFile(config.flutterSdkId);
        final icuDataFileName = p.basename(icuDataFile.path);
        final destination =
            p.join(projectDirectory.path, dotMonarch, icuDataFileName);
        await icuDataFile.copy(destination);
        log.info('icudtl.dat file copied to: $destination');
      } catch (e, s) {
        log.severe(
            'Error while copying icudtl.dat file to .monarch directory', e, s);
        stdout_default
            .writeln('Error copying resource file to .monarch directory');
        finish(TaskRunnerExitCodes.copyIcuDataFileFailed);
      }
    }
  }

  void _checkInitialTaskFinalStatus(TaskStatus taskStatus, String failedMessage,
      CliExitCode failedExitCode, CliExitCode terminatedExitCode) {
    if (taskStatus == TaskStatus.failed) {
      stdout_default.writeln(failedMessage);
      finish(failedExitCode);
    } else if (taskStatus == TaskStatus.terminated) {
      finish(terminatedExitCode);
    }
  }

  final _appLogLevelRegex = RegExp(r'^[\w :]+ (\w+)');

  Future _createLongRunningTasks() async {
    _runMonarchAppTask = ProcessReadyTask(
        taskName: TaskNames.runMonarchApp,
        executable:
            monarchBinaries.monarchAppExecutableFile(config.flutterSdkId).path,
        arguments: [
          monarchBinaries
              .controllerDirectory(config.flutterSdkId)
              .path, // controller-bundle
          p.join(projectDirectory.path, dotMonarch), // preview-bundle
          defaultLogLevel.name, // log-level
          discoveryServerPort.toString(), // discovery-server-port
          config.pubspecProjectName, // project-name
        ],
        workingDirectory: projectDirectory.path,
        analytics: analytics,
        logLevelRegex: _appLogLevelRegex,
        onStdErrMessage: onRunMonarchAppStdErrMessage,
        readyMessage: 'monarch-preview-ready');

    _runPreviewAppTask = ProcessReadyTask(
        taskName: TaskNames.runPreviewApp,
        executable:
            monarchBinaries.monarchAppExecutableFile(config.flutterSdkId).path,
        arguments: [
          'preview', // mode
          monarchBinaries
              .previewApiDirectory(config.flutterSdkId)
              .path, // preview-api-bundle
          p.join(projectDirectory.path, dotMonarch), // preview-window-bundle
          defaultLogLevel.name, // log-level
          discoveryServerPort.toString(), // discovery-server-port
        ],
        workingDirectory: projectDirectory.path,
        analytics: analytics,
        logLevelRegex: _appLogLevelRegex,
        onStdErrMessage: onRunMonarchAppStdErrMessage,
        readyMessage: 'monarch-preview-ready');

    _runControllerAppTask = ProcessReadyTask(
        taskName: TaskNames.runControllerapp,
        executable:
            monarchBinaries.monarchAppExecutableFile(config.flutterSdkId).path,
        arguments: [
          'controller', // mode
          monarchBinaries
              .controllerDirectory(config.flutterSdkId)
              .path, // controller-window-bundle
          defaultLogLevel.name, // log-level
          discoveryServerPort.toString(), // discovery-server-port
          config.pubspecProjectName, // project-name
        ],
        workingDirectory: projectDirectory.path,
        analytics: analytics,
        logLevelRegex: _appLogLevelRegex,
        onStdErrMessage: onRunMonarchAppStdErrMessage,
        readyMessage: 'monarch-controller-ready');

    _attachToReloadTask = AttachTask(
        taskName: TaskNames.attachToHotRestart,
        flutterExecutablePath: config.flutterExecutablePath,
        generatedMainFilePath: generatedMainFilePath,
        projectDirectoryPath: projectDirectory.path,
        analytics: analytics);

    _watchToRegenTask = ProcessParentReadyTask(
        taskName: TaskNames.watchToRegenMetaStories,
        executable: config.flutterExecutablePath,
        arguments: [
          'pub',
          'run',
          'build_runner',
          'watch',
          '--verbose' // must be verbose for readyMessage to print
        ],
        workingDirectory: projectDirectory.path,
        analytics: analytics,
        readyMessage: 'Build:Succeeded',
        expectReadyMessageOnce: false,
        childTaskMessages: ChildTaskMessages(
            running: 'Watch:Starting Build', done: 'Build:Succeeded'));
  }

  Future _whenMonarchAppDone() async {
    if (!_isTerminating) {
      _watchToRegenTask?.stopScrapingMessages();
      _attachToReloadTask?.stopScrapingMessages();
      await Future.delayed(Duration(milliseconds: 50), () {
        var ctrlC = valueForPlatform(macos: '⌃C', windows: 'Ctrl+C');
        stdout_default
            .writeln('\nMonarch app terminated. Press $ctrlC to exit CLI.');
      });
    }
  }

  Future _runLongRunningTasks() async {
    var taskFunctions = <Future Function()>[
      () async {
        var launching =
            TaskCountHeartbeat('Launching Monarch app', taskCount: 1)..start();

        if (Platform.isWindows) {
          await _runPreviewAppTask!.run();
          await _runControllerAppTask!.run();

          _runPreviewAppTask!.done().whenComplete(_whenMonarchAppDone);
          _runControllerAppTask!.done().whenComplete(_whenMonarchAppDone);

          _runPreviewAppTask!.stdout.listen(onMonarchAppStdoutMessage);
          _runControllerAppTask!.stdout.listen(onMonarchAppStdoutMessage);

          await _runPreviewAppTask!.ready();
          await _runControllerAppTask!.ready();
        } else {
          await _runMonarchAppTask!.run();
          _runMonarchAppTask!.done().whenComplete(_whenMonarchAppDone);
          _runMonarchAppTask!.stdout.listen(onMonarchAppStdoutMessage);
          await _runMonarchAppTask!.ready();
        }

        launching.complete();
      },
      () async {
        await _attachToReloadTask!.ready();
        await _attachToReloadTask!.attach();
      },
      () async {
        if (isReloadAutomatic) {
          var watching =
              Heartbeat('Setting up stories watch', stdout_default.writeln)
                ..start();

          await _watchToRegenTask!.run();
          await _watchToRegenTask!.ready();

          watching.complete();
        }
      },
      () async {
        if (isReloadAutomatic) {
          _regenAndReloadManager = reloadOption == ReloadOption.hotReload
              ? RegenAndHotReload(
                  stdout_: stdout_default,
                  regenTask: _watchToRegenTask!,
                  previewApi: previewApi,
                )
              : RegenRebundleAndHotRestart(
                  regenTask: _watchToRegenTask!,
                  buildPreviewBundleTask: _buildPreviewBundleTask!,
                  previewApi: previewApi,
                );

          _regenAndReloadManager!.manage();
        }
      },
      () async {
        _setUpKeyCommands();
        _printReadyMessage();
      }
    ];

    for (var taskFn in taskFunctions) {
      await taskFn();
      if (hasExited || _runMonarchAppTask!.isInFinalState) {
        return;
      }
    }
  }

  void _setUpKeyCommands() {
    var keyCommands = <KeyCommand>[];
    var helpKeyCommand = HelpKeyCommand(keyCommands, stdout_default);

    if (isReloadAutomatic) {
      keyCommands.addAll([
        HotReloadKeyCommand(
            previewApi: previewApi,
            stdout_: stdout_default,
            isDefault: reloadOption == ReloadOption.hotReload),
        HotRestartKeyCommand(
            bundleTask: _buildPreviewBundleTask!,
            previewApi: previewApi,
            stdout_: stdout_default,
            isDefault: reloadOption == ReloadOption.hotRestart),
        helpKeyCommand,
        QuitKeyCommand()
      ]);
    } else {
      keyCommands.addAll([
        GenerateAndHotReloadKeyCommand(
            stdout_: stdout_default,
            generateTask: _generateStoriesTask!,
            previewApi: previewApi),
        GenerateAndHotRestartKeyCommand(
          generateTask: _generateStoriesTask!,
          bundleTask: _buildPreviewBundleTask!,
          previewApi: previewApi,
        ),
        helpKeyCommand,
        QuitKeyCommand()
      ]);
    }

    helpKeyCommand.run();

    if (stdin_default.hasTerminal) {
      stdin_default.singleCharMode = true;
      _keystrokeSubscription = stdin_default.keystrokes
          .listen((String keystroke) => _onKeystroke(keystroke, keyCommands));
    } else {
      stdout_default.writeln(
          'stdin is not attached to an interactive terminal, key commands will not work.');
      // In an automation context, or when running the cli as part of a test,
      // stdin may not be attached to a terminal.
    }
  }

  void _onKeystroke(String keystroke, List<KeyCommand> keyCommands) {
    for (var command in keyCommands) {
      if (command.key == keystroke) {
        if (_regenAndReloadManager != null &&
            _regenAndReloadManager!.isRunning) {
          stdout_default.writeln('Try "$keystroke" again after reloading.');
          return;
        }

        if (keyCommands.any((command) => command.isRunning)) {
          stdout_default.writeln(
              'Ignoring "$keystroke". A key command is already running.');
          return;
        }

        command.run();
        return;
      }
    }
    stdout_default.writeOnly(keystroke);
  }

  void _printReadyMessage() {
    // @GOTCHA: A verification job in the monarch_automation expects 'Monarch is ready'
    const monarchIsReady = 'Monarch is ready';

    stdout_default.writeln();
    switch (reloadOption) {
      case ReloadOption.hotReload:
        stdout_default.writeln('''
$monarchIsReady. Project changes will reload automatically with hot reload.
Press "R" to force a hot restart.''');
        break;
      case ReloadOption.hotRestart:
        stdout_default.writeln('''
$monarchIsReady. Project changes will reload automatically with hot restart.''');
        break;

      case ReloadOption.manual:
        stdout_default.writeln('''
$monarchIsReady. Press "r" or "R" to reload project changes.''');
        break;

      default:
    }
  }
}
