import 'dart:convert';
import 'dart:io';

import 'package:monarch_utils/log.dart';

final _logger = Logger('StandardInput');

final stdin_default = StandardInput(stdin);

class StandardInput {
  final Stdin stdin_;

  StandardInput(this.stdin_);

  /// Reads a line from stdin. Logs it if needed.
  /// Blocks until a full line is available.
  String? readLineSync({bool shouldLogLine = false}) {
    final line = stdin_.readLineSync();
    if (shouldLogLine) {
      _logger.info(line ?? '<blank-input>');
    }
    return line;
  }

  bool get hasTerminal => stdin_.hasTerminal;

  set singleCharMode(bool value) {
    // The order of setting lineMode and echoMode is important on Windows.
    if (value) {
      stdin_.echoMode = false;
      stdin_.lineMode = false;
    } else {
      stdin_.lineMode = true;
      stdin_.echoMode = true;
    }
  }

  Stream<String>? _broadcastStdInString;

  Stream<String> get keystrokes {
    return _broadcastStdInString ??= stdin_
        .transform<String>(const AsciiDecoder(allowInvalid: true))
        .asBroadcastStream();
  }
}
