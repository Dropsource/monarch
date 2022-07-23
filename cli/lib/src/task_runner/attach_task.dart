import 'dart:async';

import 'package:monarch_io_utils/utils.dart';
import 'package:monarch_utils/log.dart';

import '../analytics/analytics.dart';
import '../utils/standard_output.dart';
import 'devtools_discovery.dart.dart';
import 'process_task.dart';

class AttachTask with Log {
  final String taskName;
  final String flutterExecutablePath;
  final String generatedMainFilePath;
  final String projectDirectoryPath;
  final Analytics analytics;

  AttachTask({
    required this.taskName,
    required this.flutterExecutablePath,
    required this.generatedMainFilePath,
    required this.projectDirectoryPath,
    required this.analytics,
  });

  ProcessParentReadyTask? _task;
  ProcessParentReadyTask? get task => _task;

  Uri? _debugUri;
  final _readyCompleter = Completer();

  set debugUri(Uri? value) {
    _debugUri = value;
    if (_debugUri != null && !_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
  }

  Uri? get debugUri => _debugUri;

  Future ready() => _readyCompleter.future;

  DevtoolsDiscovery? _devtoolsDiscovery;
  DevtoolsDiscovery? get devtoolsDiscovery => _devtoolsDiscovery;

  Future<void> attach() async {
    _task = _create();
    _devtoolsDiscovery = DevtoolsDiscovery();

    var attaching = Heartbeat('Attaching to stories', stdout_default.writeln)
      ..start();

    await _task!.run();
    _devtoolsDiscovery!.listen(_task!.stdout);
    await _task!.ready();

    attaching.complete();

    Future.delayed(Duration(seconds: 5), _devtoolsDiscovery!.cancel);
  }

  ProcessParentReadyTask _create() {
    var debugUri_ =
        '${debugUri!.scheme}://${debugUri!.host}:${debugUri!.port}${debugUri!.path}';
    log.info('debug-uri=$debugUri_');
    return ProcessParentReadyTask(
        taskName: taskName,
        executable: flutterExecutablePath,
        arguments: [
          'attach',
          '--debug',
          '-d',
          valueForPlatform(macos: 'macOS', windows: 'Windows'),
          '-t',
          generatedMainFilePath,
          '--debug-uri',
          debugUri_,

          /// '--isolate-filter=monarch-isolate', // 2020-06-05: did not work when bypassing desktop check on stable channel
          /// if (isVerbose) '--verbose' // 2020-06-05: attach verbose flag is very noisy. If set, you will have to change the child task messages.
        ],
        workingDirectory: projectDirectoryPath,
        analytics: analytics,
        readyMessage: valueForPlatform(
            macos: 'An Observatory debugger and profiler on macOS is available',
            windows:
                'An Observatory debugger and profiler on Windows is available'),
        childTaskMessages: ChildTaskMessages(
            running: RegExp(r'(Performing hot restart|Performing hot reload)'),
            done: RegExp(
                r'(Restarted application|Reloaded \d+ of \d+ libraries|Reloaded \d+ libraries)'),
            failed: 'Try again after fixing the above error(s).'));
  }

  void kill() {
    stopScrapingMessages();
    _task!.terminate();
  }

  void stopScrapingMessages() {
    _task?.stopScrapingMessages();
  }
}
