import 'dart:convert';
import 'dart:io';
import 'process_utils.dart';

/// Runs a process non-interactively to completion. It exposes the process
/// output through convinience getters.
///
/// It is ideal to run shell or CLI commands that start and run to completion
/// without interaction.
class NonInteractiveProcess {
  final String executable;
  final List<String> arguments;
  final String? workingDirectory;
  final Encoding encoding;

  NonInteractiveProcess(this.executable, this.arguments,
      {this.workingDirectory,
      List<int>? successExitCodes,
      this.encoding = systemEncoding}) {
    if (successExitCodes != null) {
      _successExitCodes = successExitCodes;
    }
  }

  late ProcessResult _result;
  ProcessResult get result => _result;

  List<int> _successExitCodes = [0];
  bool get isSuccess => _successExitCodes.contains(_result.exitCode);

  late String _stdout;
  String get stdout => _stdout;

  late String _stderr;
  String get stderr => _stderr;

  String get prettyCmd => getPrettyCommand(executable, arguments);

  /// Starts the process or command and runs it non-interactively to completion.
  Future<void> run() async {
    _result = await Process.run(executable, arguments,
        workingDirectory: workingDirectory,
        runInShell: Platform.isWindows,
        stdoutEncoding: encoding,
        stderrEncoding: encoding);

    _stdout = _result.stdout;
    _stderr = _result.stderr;
  }

  /// Starts the process or command and runs it non-interactively to completion.
  /// This is a synchronous call and will block until the child process terminates.
  void runSync() {
    _result = Process.runSync(executable, arguments,
        workingDirectory: workingDirectory,
        runInShell: Platform.isWindows,
        stdoutEncoding: encoding,
        stderrEncoding: encoding);

    _stdout = _result.stdout;
    _stderr = _result.stderr;
  }

  String getOutputMessage() {
    return '''
command-output exit_code=${result.exitCode} success=$isSuccess 
command="$prettyCmd"
working_directory="${workingDirectory ?? '(not provided)'}"
stdout:
${stdout.isEmpty ? '(blank)' : stdout}

stderr:
${stderr.isEmpty ? '(blank)' : stderr}''';
  }
}
