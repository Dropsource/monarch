@TestOn('windows')

import 'dart:convert';
import 'package:test/test.dart';
import 'package:monarch_io_utils/src/non_interactive_process.dart';

void main() {
  group('NonInteractiveProcess', () {
    test('reads unicode file with default system encoding', () async {
      var runner =
          NonInteractiveProcess('type', [r'.\test\unicode_test_file.txt']);
      await runner.run();
      expect(runner.stdout, 'foo 1.2.3 â€¢ bar baz â€¢ https://abc.co/def');
    });

    test('reads unicode file using utf8 codec', () async {
      var runner = NonInteractiveProcess(
          'type', [r'.\test\unicode_test_file.txt'],
          encoding: Utf8Codec());
      await runner.run();
      expect(runner.stdout, 'foo 1.2.3 • bar baz • https://abc.co/def');
    });
  });
}
