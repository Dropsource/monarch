import 'package:test/test.dart';
import 'package:dropsource_storybook_utils/log.dart';

void main() {
  group('LogLevel', () {
    test('fromString', () {
      LogLevel level;

      level = LogLevel.fromString('INFO', LogLevel.FINE);
      expect(level, LogLevel.INFO);

      level = LogLevel.fromString('SEVERE', LogLevel.FINE);
      expect(level, LogLevel.SEVERE);

      level = LogLevel.fromString('NOT_A_LEVEL', LogLevel.FINE);
      expect(level, LogLevel.FINE);

      level = LogLevel.fromString(null, LogLevel.FINE);
      expect(level, LogLevel.FINE);
    });
  });
}