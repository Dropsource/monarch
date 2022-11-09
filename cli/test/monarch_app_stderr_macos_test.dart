@TestOn('mac-os')

import 'package:test/test.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';
import 'package:monarch_cli/src/task_runner/monarch_app_stderr.dart';

void main() {
  group('onRunMonarchAppStdErrMessage', () {
    test('ignores CFBundle error message on macos', () async {
      var message =
          '2021-05-13 19:14:16.165 monarch[70530:10028639] Cannot find executable for CFBundle 0x7fc54466d140 </path/to/project/.monarch> (not loaded)';

      var logEntries = <LogEntry>[];
      logEntryStream.listen((logEntry) => logEntries.add(logEntry));

      var _logger = Logger('monarch-app-stderr-test');
      onRunMonarchAppStdErrMessage(message, _logger);

      await pumpEventQueue();

      expect(logEntries.length, 1);
      expect(logEntries[0].level, LogLevel.INFO);
      expect(logEntries[0].message,
          '**ignored-severe** 2021-05-13 19:14:16.165 monarch[70530:10028639] Cannot find executable for CFBundle 0x7fc54466d140 </path/to/project/.monarch> (not loaded)');
      expect(logEntries[0].errorDetails, isNull);
      expect(logEntries[0].stackTrace, isNull);
    });
  });
}
