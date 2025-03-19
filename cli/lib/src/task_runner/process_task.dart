import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:io/io.dart';

import 'package:monarch_utils/log.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';

import '../analytics/analytics.dart';
import 'log_level_parser.dart';
import 'task.dart';

const killSignalExitCode = -15;

class ProcessTaskStateError extends StateError {
  ProcessTaskStateError.getterNotNull(
      String getterName, String preconditionMethod)
      : super(
            '$getterName is not set, method $preconditionMethod must be called and awaited first');
}

typedef OnStdErrMessageFn = void Function(String, Logger);

class ProcessTask implements Task {
  final String taskName;
  final String executable;
  final List<String> arguments;
  final String workingDirectory;
  final RegExp? logLevelRegex;
  final Analytics analytics;
  final OnStdErrMessageFn? onStdErrMessage;

  final Logger _logger;

  List<int> _successExitCodes = [ExitCode.success.code];

  Process? _process;
  late Stream<String> _stdout;
  late Stream<String> _stderr;
  int? _exitCode;
  bool _isStdoutDone = false;
  bool _isStderrDone = false;

  Process? get process => _process;
  Stream<String> get stdout => _stdout;
  Stream<String> get stderr => _stderr;
  int? get exitCode => _exitCode;
  bool get isExitCodeSuccessful {
    if (exitCode == null) {
      throw ProcessTaskStateError.getterNotNull('exitCode', 'done');
    }
    return _successExitCodes.contains(exitCode!);
  }

  Logger get logger => _logger;

  ProcessTask(
      {required this.taskName,
      required this.executable,
      required this.arguments,
      required this.workingDirectory,
      required this.analytics,
      List<int>? successExitCodes,
      this.logLevelRegex,
      this.onStdErrMessage})
      : _logger = Logger(taskName) {
    if (successExitCodes != null) {
      _successExitCodes = successExitCodes;
    }
  }

  TaskStatus _status = TaskStatus.created;

  @override
  TaskStatus get status => _status;

  bool get isInFinalState =>
      _status == TaskStatus.done ||
      _status == TaskStatus.failed ||
      _status == TaskStatus.terminated;

  final Stopwatch _runningStopwatch = Stopwatch();

  @override
  Future run() async {
    _runningStopwatch.start();
    _process = await Process.start(executable, arguments,
        workingDirectory: workingDirectory, runInShell: Platform.isWindows);

    _status = TaskStatus.running;
    _logger.info('task_pid=${_process!.pid}  task_command="$prettyCommand"');

    _stdout = transformProcessStream(process!.stdout);
    _stderr = transformProcessStream(process!.stderr);

    _stdout.listen(
        logLevelRegex == null ? _logger.fine : _logUsingMessageLogLevel,
        onDone: () => _isStdoutDone = true);
    _stderr.listen(
        (msg) => onStdErrMessage != null
            ? onStdErrMessage!(msg, _logger)
            : _logger.severe(msg),
        onDone: () => _isStderrDone = true);
  }

  void _logUsingMessageLogLevel(String message) {
    final logLevel = parseLogLevel(message, logLevelRegex!, LogLevel.FINE);
    _logger.log(logLevel, message);
  }

  @override
  Future done() async {
    if (process == null) {
      throw ProcessTaskStateError.getterNotNull('process', 'run');
    }

    _exitCode = await process!.exitCode;
    await whileTrueTimeout(() => !_isStdoutDone, 'Process.stdout');
    await whileTrueTimeout(() => !_isStderrDone, 'Process.stderr');

    if (!isInFinalState) {
      _runningStopwatch.stop();
      _logger.info('Task done after $_runningStopwatch');
      _setDoneStatus();
    }
  }

  Future<void> whileTrueTimeout(bool Function() isTrue, String streamName) {
    return whileTrue(isTrue).timeout(Duration(milliseconds: 100),
        onTimeout: () => logger.warning(
            'Time limit reached while waiting on $streamName to be done'));
  }

  void _setDoneStatus() {
    if (isExitCodeSuccessful) {
      _status = TaskStatus.done;
      _logger.fine('Process finished successfully with exit code $exitCode');
      analytics.task_done(taskName, _runningStopwatch.duration);
    } else {
      _status = TaskStatus.failed;
      _logger
          .warning('Process did not finish successfully, exit code $exitCode');
    }
  }

  String get prettyCommand => getPrettyCommand(executable, arguments);

  @override
  void throwIfFailed() {
    if (_exitCode == null) {
      throw ProcessTaskStateError.getterNotNull('exitCode', 'done');
    }
    if (!isExitCodeSuccessful) {
      throw '"$prettyCommand" process did not finish successfully';
    }
  }

  @override
  void terminate() {
    _runningStopwatch.stop();
    _logger.info('Terminating task after $_runningStopwatch');
    _kill();
  }

  void _kill() {
    if (_process == null) {
      _logger.warning('Attempting to kill process that was not started');
    } else {
      final signalDelivered = _process!.kill();

      if (signalDelivered) {
        _logger.fine('kill signal delivered to process');
      } else {
        _logger
            .fine('kill signal not delivered to process, may be already dead');
      }

      _status = TaskStatus.terminated;
      _logger.fine('"$prettyCommand" process killed');
    }
  }

  static Stream<String> transformProcessStream(
      Stream<List<int>> standardStream) {
    return standardStream.transform(utf8.decoder).asBroadcastStream();
  }
}

class ProcessReadyTask extends ProcessTask implements ReadyTask {
  final String readyMessage;
  final bool expectReadyMessageOnce;

  ProcessReadyTask(
      {required super.taskName,
      required super.executable,
      required super.arguments,
      required super.workingDirectory,
      required super.analytics,
      super.logLevelRegex,
      super.successExitCodes,
      super.onStdErrMessage,
      required this.readyMessage,
      this.expectReadyMessageOnce = true});

  Completer? _readyCompleter;
  final _readyStopwatch = Stopwatch();

  StreamSubscription? _readyMessageSubscription;

  @override
  Future run() async {
    _readyStopwatch.start();
    await super.run();
    _readyCompleter = Completer();
    _readyMessageSubscription = super.stdout.listen((message) {
      if (message.contains(readyMessage)) {
        if (_readyCompleter!.isCompleted) {
          if (expectReadyMessageOnce) {
            logger.warning('Expected ready message once but got it again');
          }
        } else {
          _readyCompleter!.complete();
        }
      }
    });
  }

  @override
  Future ready() async {
    if (_readyCompleter == null) {
      throw ProcessTaskStateError.getterNotNull('readyCompleter', 'run');
    }
    await _readyCompleter!.future;
    _status = TaskStatus.ready;
    _readyStopwatch.stop();
    logger.info('Task is ready after $_readyStopwatch');
    analytics.task_ready(taskName, _readyStopwatch.duration);
  }

  @override
  void terminate() {
    super.terminate();
    if (_readyCompleter != null && !_readyCompleter!.isCompleted) {
      logger.fine('Task terminated while getting ready');
      _readyCompleter!.complete();
    }
  }

  void stopScrapingMessages() {
    _readyMessageSubscription?.cancel();
    if (_readyCompleter != null && !_readyCompleter!.isCompleted) {
      logger.info('Stopped scraping ready messages');
      _readyCompleter!.complete();
    }
  }
}

enum ChildTaskStatus { running, done, failed }

class ProcessParentReadyTask extends ProcessReadyTask {
  ChildTaskStatus? _childTaskStatus;
  ChildTaskStatus? get childTaskStatus => _childTaskStatus;

  final _childTaskStatusStreamController =
      StreamController<ChildTaskStatus>.broadcast();
  Stream<ChildTaskStatus> get childTaskStatusStream =>
      _childTaskStatusStreamController.stream;

  final ChildTaskMessages childTaskMessages;

  StreamSubscription? _childTaskMessagesSubscription;

  ProcessParentReadyTask(
      {required super.taskName,
      required super.executable,
      required super.arguments,
      required super.workingDirectory,
      required super.analytics,
      super.successExitCodes,
      required super.readyMessage,
      super.expectReadyMessageOnce,
      required this.childTaskMessages});

  @override
  Future run() async {
    await super.run();
    _childTaskMessagesSubscription = super.stdout.listen((message) {
      if (message.contains(childTaskMessages.running)) {
        _setChildTaskStatus(ChildTaskStatus.running);
      } else if (message.contains(childTaskMessages.done)) {
        _setChildTaskStatus(ChildTaskStatus.done);
      } else if (childTaskMessages.hasFailedMessage &&
          message.contains(childTaskMessages.failed!)) {
        _setChildTaskStatus(ChildTaskStatus.failed);
      }
    });
  }

  void _setChildTaskStatus(ChildTaskStatus status) {
    _childTaskStatus = status;
    _childTaskStatusStreamController.add(_childTaskStatus!);
  }

  @override
  void stopScrapingMessages() {
    super.stopScrapingMessages();
    _childTaskMessagesSubscription?.cancel();
    logger.info('Stopped scrapping child task messages');
  }
}

class ChildTaskMessages {
  final Pattern running;
  final Pattern done;
  final String? failed;

  bool get hasFailedMessage => failed != null && failed!.isNotEmpty;

  ChildTaskMessages({required this.running, required this.done, this.failed});
}
