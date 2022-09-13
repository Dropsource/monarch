import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:io/io.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'standard_output.dart';

/// A process that can be started and terminated. It exposes decoded stdout
/// and stderr streams. It also provides convinience getters.
///
/// Useful for long-running commands
/// or commands that the user may want to terminate during execution.
///
/// For simpler, short-lived commands see [NonInteractiveProcess] in
/// `package:monarch_io_utils`.
class ManagedProcess {
  final String loggerName;
  final String executable;
  final List<String> arguments;
  final String? workingDirectory;

  final Logger logger;

  ManagedProcess(
      {required this.loggerName,
      required this.executable,
      required this.arguments,
      this.workingDirectory})
      : logger = Logger(loggerName);

  Process? _process;
  late final Stream<List<int>> _stdout;
  late final Stream<List<int>> _stderr;
  late final Stream<String> _decodedStdout;
  late final Stream<String> _decodedStderr;
  int? _exitCode;
  bool _isStdoutDone = false;
  bool _isStderrDone = false;

  Process? get process => _process;
  Stream<List<int>> get stdout => _stdout;
  Stream<List<int>> get stderr => _stderr;
  Stream<String> get decodedStdout => _decodedStdout;
  Stream<String> get decodedStderr => _decodedStderr;

  Future<void> start() async {
    _process = await Process.start(executable, arguments,
        workingDirectory: workingDirectory, runInShell: Platform.isWindows);

    _stdout = _process!.stdout.asBroadcastStream();
    _stderr = _process!.stderr.asBroadcastStream();

    _decodedStdout = _stdout.transform(utf8.decoder);
    _decodedStderr = _stderr.transform(utf8.decoder);

    _stdout.listen((_) => {}, onDone: () => _isStdoutDone = true);
    _stderr.listen((_) => {}, onDone: () => _isStderrDone = true);
  }

  Future<void> done() async {
    if (_process == null) {
      throw StateError('process is not set, method start must be called first');
    }
    _exitCode = await _process!.exitCode;

    await whileTrueTimeout(() => !_isStdoutDone, 'Process.stdout');
    await whileTrueTimeout(() => !_isStderrDone, 'Process.stderr');
  }

  bool get isSuccess {
    if (_exitCode == null) {
      throw StateError(
          'exitCode is not set, method done must be called and awaited first');
    }
    return _exitCode == ExitCode.success.code;
  }

  bool _isTerminated = false;
  bool get isTerminated => _isTerminated;

  String exitMessage() {
    if (_exitCode == null) {
      throw StateError(
          'exitCode is not set, method done must be called and awaited first');
    }
    return 'command="$prettyCmd" exit_code=$_exitCode is_success_code=$isSuccess is_terminated=$isTerminated';
  }

  String get prettyCmd => getPrettyCommand(executable, arguments);

  Future<void> whileTrueTimeout(bool Function() isTrue, String streamName) {
    return whileTrue(isTrue).timeout(Duration(milliseconds: 100),
        onTimeout: () => logger.warning(
            'Time limit reached while waiting on $streamName to be done'));
  }

  void terminate() {
    logger.info('Terminating process');
    _kill();
    _isTerminated = true;
  }

  void _kill() {
    if (_process == null) {
      logger.warning('Attempting to kill process that was not started');
    } else {
      _process!.kill();
      logger.fine('"$prettyCmd" process killed');
    }
  }
}

/// A [ManagedProcess] that throws if it is terminated or
/// unsuccessful. It also lets derived classes set up their own
/// stdout and stderr streams after the process starts.
abstract class ThrowsManagedProcess extends ManagedProcess {
  ThrowsManagedProcess(
      {required String loggerName,
      required String executable,
      required List<String> arguments,
      String? workingDirectory})
      : super(
            loggerName: loggerName,
            executable: executable,
            arguments: arguments,
            workingDirectory: workingDirectory);

  @override
  Future<void> start() async {
    await super.start();
    await didStart();
  }

  Future<void> didStart();

  @override
  Future<void> done() async {
    await super.done();

    if (isSuccess || isTerminated) {
      logger.fine(exitMessage());
    } else {
      logger.warning(exitMessage());
    }

    if (isTerminated) {
      throw ProcessTerminatedException();
    }

    if (!isSuccess) {
      throw ProcessFailedException();
    }
  }
}

class ProcessFailedException implements Exception {}

class ProcessTerminatedException implements Exception {}

/// Downloads a remote file from `downloadUrl` to the local
/// `destinationDirectory`.
class Downloader extends ThrowsManagedProcess {
  Downloader(
      {required String downloadUrl, required Directory destinationDirectory})
      : super(
            loggerName: 'Downloader',
            executable: 'curl',
            arguments: ['-O', downloadUrl],
            workingDirectory: destinationDirectory.path);

  @override
  Future<void> didStart() async {
    stdout_default.addStream(super.stdout);
    unawaited(stderr.addStream(super.stderr));

    decodedStdout.listen(logger.fine);
    // curl prints out progress in stderr
    decodedStderr.listen(logger.fine);
  }
}

/// Unzips a local zip file into its parent directory. For example, if there is
/// a zip file at /foo/bar/baz.zip, then this class will unzip baz.zip into
/// /foo/bar.
class Unzipper extends ThrowsManagedProcess {
  Unzipper(
      {required String zipFileName, required Directory zipFileParentDirectory})
      : super(
            loggerName: 'Unzipper',
            executable: valueForPlatform(macos: 'unzip', windows: 'tar'),
            arguments: valueForPlatform(
                macos: ['-q', zipFileName], windows: ['-x', '-f', zipFileName]),
            workingDirectory: zipFileParentDirectory.path);

  @override
  Future<void> didStart() async {
    decodedStdout.listen(logger.fine);
    decodedStderr.listen(logger.warning);
  }
}

class FlutterPubGet extends ThrowsManagedProcess {
  FlutterPubGet({required Directory projectDirectory, required String flutterExecutablePath})
      : super(
            loggerName: 'FlutterPubGet',
            executable: flutterExecutablePath,
            arguments: ['pub', 'get'],
            workingDirectory: projectDirectory.path);

  @override
  Future<void> didStart() async {
    stdout_default.addStream(super.stdout);
    unawaited(stderr.addStream(super.stderr));

    decodedStdout.listen(logger.fine);
    decodedStderr.listen(logger.warning);
  }
}
