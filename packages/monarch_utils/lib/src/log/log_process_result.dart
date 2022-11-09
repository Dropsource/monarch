import 'dart:io';
import 'log.dart';

void logUnsuccessfulProcessResult(ProcessResult result, Log _log) {
  final stdout = result.stdout;
  final stderr = result.stderr;

  if (stdout is String) {
    _log.log.severe('stdout output:\n$stdout');
  }

  if (stderr is String && stderr.isNotEmpty) {
    _log.log.severe('stderr output:\n$stderr');
  }
}
