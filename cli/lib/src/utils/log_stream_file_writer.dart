import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'standard_output.dart';
import '../config/application_support_directory.dart';
import 'list_utils.dart';

class LogStreamFileWriter with Log {
  final Stream<LogEntry> logEntryStream;
  final String commandDescription;
  final bool isVerbose;
  final bool printTimestamp;
  final bool printLoggerName;

  IOSink? _logSink;
  StreamSubscription? _subscription;
  File? _tempFile;

  LogStreamFileWriter(
      this.logEntryStream, this.commandDescription, this.isVerbose,
      {required this.printTimestamp, required this.printLoggerName});

  void setUp() {
    _logToTmpFile();
    final helper = SaveLogFilePathHelper(commandDescription, _tempFile!);
    helper.saveLogFilePath();
  }

  void _logToTmpFile() {
    _tempFile = _createTempFile('monarch_cli_', 'log_monarch_cli.log');
    if (isVerbose) {
      stdout_default.writeln('Writing application logs to ${_tempFile!.path}');
    }
    _logSink =
        _tempFile!.openWrite(mode: FileMode.writeOnlyAppend, encoding: utf8);

    _subscription = writeLogEntryStream(_logSink!.writeln,
        printTimestamp: printTimestamp, printLoggerName: printLoggerName);
  }

  File _createTempFile(String tempDirectoryPrefix, String fileName) {
    var dir = Directory.systemTemp.createTempSync(tempDirectoryPrefix);
    var temp = File(p.join(dir.path, fileName));
    temp.createSync();
    return temp;
  }

  Future<void> tearDown() async {
    log.info('Closing temp file log');
    await _subscription?.cancel();
    await _logSink?.flush();
    await _logSink?.close();

    if (isVerbose) {
      stdout_default.writeln('Application logs written to ${_tempFile?.path}');
    }
  }
}

class SaveLogFilePathHelper with Log {
  final String commandDescription;
  final File logFilePath;

  SaveLogFilePathHelper(this.commandDescription, this.logFilePath);

  Future<void> saveLogFilePath() async {
    if (ApplicationSupportDirectory.isValid) {
      final file = ApplicationSupportDirectory.logsInfoFile;
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
      final lines = await file.readAsLines();
      lines.add(_getLogInfoLine());
      const threshold = 30;
      trimStartIfNeeded(lines, threshold);
      await file.writeAsString(lines.join('\n'), flush: true);
    } else {
      log.warning(ApplicationSupportDirectory.notValidMessage);
    }
  }

  String _getLogInfoLine() =>
      '${DateTime.now()} [$commandDescription] [${logFilePath.path}]';
}
