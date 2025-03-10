@TestOn('windows')
library;

import 'package:test/test.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';
import 'package:monarch_cli/src/task_runner/monarch_app_stderr.dart';

void main() {
  group('onRunMonarchAppStdErrMessage', () {
    test('ignores "Could not create a resource..." message on Windows', () async {
      var message =
          '2021-05-13 19:14:16.165 monarch[70530:10028639] Could not create a resource context for async texture uploads. Expect degraded performance. Set a valid make_resource_current callback on FlutterOpenGLRendererConfig.';

      var logEntries = <LogEntry>[];
      logEntryStream.listen((logEntry) => logEntries.add(logEntry));

      var logger_ = Logger('run-preview-app');
      onRunMonarchAppStdErrMessage(message, logger_);

      await pumpEventQueue();

      expect(logEntries.length, 1);
      expect(logEntries[0].level, LogLevel.INFO);
      expect(logEntries[0].message,
          '**ignored-severe** $message');
      expect(logEntries[0].errorDetails, isNull);
      expect(logEntries[0].stackTrace, isNull);
    });

    test('ignores "Could not make the context..." message on Windows', () async {
      var message = '2022-12-02 14:31:26.078 Monarch[96310:74098747] Could not make the context current to set up the Gr context.';

      var logEntries = <LogEntry>[];
      logEntryStream.listen((logEntry) => logEntries.add(logEntry));

      var logger_ = Logger('run-preview-app');
      onRunMonarchAppStdErrMessage(message, logger_);

      await pumpEventQueue();

      expect(logEntries.length, 1);
      expect(logEntries[0].level, LogLevel.INFO);
      expect(logEntries[0].message, '**ignored-severe** $message');
      expect(logEntries[0].errorDetails, isNull);
      expect(logEntries[0].stackTrace, isNull);
    });

    test('ignores "Failed to create platform..." message on Windows on a multi line message', () async {
      var message = '''
2022-12-02 14:31:26.078 Monarch[96310:74098747] abc

2022-12-02 14:31:26.078 Monarch[96310:74098747] Failed to create platform view rendering surface

''';

      var logEntries = <LogEntry>[];
      logEntryStream.listen((logEntry) => logEntries.add(logEntry));

      var logger_ = Logger('run-preview-app');
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
