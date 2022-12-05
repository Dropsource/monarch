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

      var logger_ = Logger('monarch-app-stderr-test');
      onRunMonarchAppStdErrMessage(message, logger_);

      await pumpEventQueue();

      expect(logEntries.length, 1);
      expect(logEntries[0].level, LogLevel.INFO);
      expect(logEntries[0].message,
          '**ignored-severe** 2021-05-13 19:14:16.165 monarch[70530:10028639] Cannot find executable for CFBundle 0x7fc54466d140 </path/to/project/.monarch> (not loaded)');
      expect(logEntries[0].errorDetails, isNull);
      expect(logEntries[0].stackTrace, isNull);
    });

    test('ignores CFBundle monarch_controller message on single line', () async {
      var message = '2022-12-02 14:31:26.078 Monarch[96310:74098747] Cannot find executable for CFBundle 0x7fe5321782b0 </Users/fertrig/development/monarch_product/dist_prod/monarch/bin/cache/monarch_ui/flutter_macos_3.3.7-stable/monarch_controller> (not loaded)';

      var logEntries = <LogEntry>[];
      logEntryStream.listen((logEntry) => logEntries.add(logEntry));

      var logger_ = Logger('monarch-app-stderr-test');
      onRunMonarchAppStdErrMessage(message, logger_);

      await pumpEventQueue();

      expect(logEntries.length, 1);
      expect(logEntries[0].level, LogLevel.INFO);
      expect(logEntries[0].message, '**ignored-severe** $message');
      expect(logEntries[0].errorDetails, isNull);
      expect(logEntries[0].stackTrace, isNull);
    });

    test('ignores CFBundle multi line message', () async {
      var message = '''
2022-12-02 14:31:26.078 Monarch[96310:74098747] Cannot find executable for CFBundle 0x7fe5322379a0 </Users/fertrig/development/monarch_product/dist_prod/monarch/bin/cache/monarch_ui/flutter_macos_3.3.7-stable/monarch_preview_api> (not loaded)

2022-12-02 14:31:26.078 Monarch[96310:74098747] Cannot find executable for CFBundle 0x7fe532177b80 </Users/fertrig/development/scratch/audios/.monarch> (not loaded)

''';

      var logEntries = <LogEntry>[];
      logEntryStream.listen((logEntry) => logEntries.add(logEntry));

      var logger_ = Logger('monarch-app-stderr-test');
      onRunMonarchAppStdErrMessage(message, logger_);

      await pumpEventQueue();

      expect(logEntries.length, 1);
      expect(logEntries[0].level, LogLevel.INFO);
      expect(logEntries[0].message, '**ignored-severe** $message');
      expect(logEntries[0].errorDetails, isNull);
      expect(logEntries[0].stackTrace, isNull);
    });
  });
}
