import 'package:monarch_io_utils/src/string_utils.dart';
import 'package:test/test.dart';

void main() {
  group('string utils', () {
    group('hardWrap', () {
      test('0 line breaks', () {
        expect(hardWrap('abc'), 'abc');
        expect(hardWrap('abc', lineLength: 1), 'abc');
        expect(hardWrap('abc', lineLength: 2), 'abc');
        expect(hardWrap('abc', lineLength: 3), 'abc');
        expect(hardWrap('abc', lineLength: 4), 'abc');
      });

      test('1 line break or less', () {
        expect(hardWrap('abc def'), 'abc def');
        expect(hardWrap('abc def', lineLength: 1), 'abc\ndef');
        expect(hardWrap('abc def', lineLength: 2), 'abc\ndef');
        expect(hardWrap('abc def', lineLength: 3), 'abc\ndef');
        expect(hardWrap('abc def', lineLength: 4), 'abc\ndef');
        expect(hardWrap('abc def', lineLength: 5), 'abc def');
      });

      test('2 line breaks or less', () {
        expect(hardWrap('abc mnpq xy z'), 'abc mnpq xy z');
        expect(hardWrap('abc mnpq xy z', lineLength: 3), 'abc\nmnpq\nxy\nz');
        expect(hardWrap('abc mnpq xy z', lineLength: 4), 'abc\nmnpq\nxy z');
        expect(hardWrap('abc mnpq xy z', lineLength: 5), 'abc mnpq\nxy z');
        expect(hardWrap('abc mnpq xy z', lineLength: 6), 'abc mnpq\nxy z');
        expect(hardWrap('abc mnpq xy z', lineLength: 7), 'abc mnpq\nxy z');
        expect(hardWrap('abc mnpq xy z', lineLength: 8), 'abc mnpq\nxy z');
        expect(hardWrap('abc mnpq xy z', lineLength: 9), 'abc mnpq\nxy z');
        expect(hardWrap('abc mnpq xy z', lineLength: 10), 'abc mnpq xy\nz');
        expect(hardWrap('abc mnpq xy z', lineLength: 11), 'abc mnpq xy\nz');
        expect(hardWrap('abc mnpq xy z', lineLength: 12), 'abc mnpq xy\nz');
        expect(hardWrap('abc mnpq xy z', lineLength: 13), 'abc mnpq xy z');
      });

      test('paragraph', () {
        expect(
            hardWrap(
                'Two ways to view newlines, both of which are self-consistent, are that newlines either separate lines or that they terminate lines. If a newline is considered a separator, there will be no newline after the last line of a file. Some programs have problems processing the last line of a file if it is not terminated by a newline. On the other hand, programs that expect newline to be used as a separator will interpret a final newline as starting a new (empty) line. Conversely, if a newline is considered a terminator, all text lines including the last are expected to be terminated by a newline. If the final character sequence in a text file is not a newline, the final line of the file may be considered to be an improper or incomplete text line, or the file may be considered to be improperly truncated.'),
            'Two ways to view newlines, both of which are self-consistent, are that newlines\n'
            'either separate lines or that they terminate lines. If a newline is considered a\n'
            'separator, there will be no newline after the last line of a file. Some programs\n'
            'have problems processing the last line of a file if it is not terminated by a newline.\n'
            'On the other hand, programs that expect newline to be used as a separator will interpret\n'
            'a final newline as starting a new (empty) line. Conversely, if a newline is considered\n'
            'a terminator, all text lines including the last are expected to be terminated by\n'
            'a newline. If the final character sequence in a text file is not a newline, the\n'
            'final line of the file may be considered to be an improper or incomplete text line,\n'
            'or the file may be considered to be improperly truncated.');
      });
    });
  });
}
