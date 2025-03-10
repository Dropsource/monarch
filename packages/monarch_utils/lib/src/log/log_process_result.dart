import 'dart:io';
import 'log.dart';

void logUnsuccessfulProcessResult(ProcessResult result, Log log_) {
  final stdout = result.stdout;
  final stderr = result.stderr;

  if (stdout is String) {
    log_.log.severe('stdout output:\n$stdout');
  }

  if (stderr is String && stderr.isNotEmpty) {
    log_.log.severe('stderr output:\n$stderr');
  }
}
