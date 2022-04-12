import 'dart:async';
import 'dart:io';

import 'package:monarch_utils/log.dart';

final _logger = Logger('StandardOutput');

/// Prefer to use [stdout_default] over the global [stdout] so we can log and 
/// redirect output as needed.
final stdout_default = StandardOutput(stdout);

/// Wraps an IOSink. It logs IOSink.write* calls. It can also be used to redirect
/// streams from other processes into the wrapped IOSink.
/// 
/// Its default instance, [stdout_default], passes this program's [stdout] as the
/// IOSink. You can pass your own sink from tests, which is useful to verify
/// the output the user will see.
class StandardOutput {
  final IOSink sink;

  StandardOutput(this.sink);

  /// Prints messages we want the user to see. The messages should be user-friendly
  /// and meant for progress updates. They are not meant for application logs.
  void writeln([String message = '']) {
    _logger.info(message.trim());
    writelnOnly(message);
  }

  void writelnOnly(String message) async {
    if (isAddingStream) {
      await addStreamDone;
    }
    sink.writeln(message);
  }

  void write(String message) {
    _logger.info(message.trim());
    writeOnly(message);
  }

  void writeOnly(String message) async {
    if (isAddingStream) {
      await addStreamDone;
    }
    sink.write(message);
  }

  Completer? _addStreamCompleter;
  Future get addStreamDone => _addStreamCompleter!.future;

  void addStream(Stream<List<int>> stream) async {
    _addStreamCompleter = Completer();
    await sink.addStream(stream);
    await sink.flush();
    _addStreamCompleter!.complete();
  }

  bool get isAddingStream =>
      _addStreamCompleter != null && !_addStreamCompleter!.isCompleted;
}
