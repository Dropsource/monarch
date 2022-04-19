import 'package:monarch_utils/log.dart';
import 'package:test/test.dart';
import 'package:monarch_cli/src/task_runner/log_level_parser.dart';

void main() {
  group('parseLogLevel()', () {
    group('extracts log levels ', () {
      test('from builder log messeges', () {
        final logLevelRegex = RegExp(r'^\[(\w+)\]');
        var logLevel;
        var fallbackLogLevel = LogLevel.FINE;

        logLevel = parseLogLevel(
            '[SEVERE] monarch:meta_stories_builder on stories/helper.meta_themes.g.dart:',
            logLevelRegex,
            fallbackLogLevel);
        expect(logLevel, LogLevel.SEVERE);

        logLevel = parseLogLevel(
            '[INFO] monarch:meta_stories_builder on stories/helper.meta_themes.g.dart:',
            logLevelRegex,
            fallbackLogLevel);
        expect(logLevel, LogLevel.INFO);

        logLevel = parseLogLevel(
            'monarch:meta_stories_builder on stories/helper.meta_themes.g.dart:',
            logLevelRegex,
            fallbackLogLevel);
        expect(logLevel, LogLevel.FINE);

        logLevel = parseLogLevel(
            '[NOT_A_LEVEL] monarch:meta_stories_builder on stories/helper.meta_themes.g.dart:',
            logLevelRegex,
            fallbackLogLevel);
        expect(logLevel, LogLevel.FINE);
      });

      test('from mac_app log messages', () {
        final logLevelRegex = RegExp(r'^\w+: (\w+)');
        var logLevel;
        var fallbackLogLevel = LogLevel.FINE;

        logLevel = parseLogLevel(
            'mac_app: FINEST [MainWindowController] received channel method: dropsource.monarch.ping',
            logLevelRegex,
            fallbackLogLevel);
        expect(logLevel, LogLevel.FINEST);

        logLevel = parseLogLevel(
            'flutter: INFO [Start] Starting monarch flutter app',
            logLevelRegex,
            fallbackLogLevel);
        expect(logLevel, LogLevel.INFO);

        logLevel = parseLogLevel('foo', logLevelRegex, fallbackLogLevel);
        expect(logLevel, LogLevel.FINE);

        logLevel = parseLogLevel(
            'flutter: NOT_A_LEVEL [Start] Starting monarch flutter app',
            logLevelRegex,
            fallbackLogLevel);
        expect(logLevel, LogLevel.FINE);
      });
    });
  });
}
