import 'package:monarch_cli/src/utils/list_utils.dart';
import 'package:test/test.dart';

void main() {
  group('trimStartIfNeeded', () {
    test('boundaries', () {
      List list;

      list = [];
      trimStartIfNeeded(list, 30);
      expect(list, []);

      list = ['a'];
      trimStartIfNeeded(list, 1);
      expect(list, ['a']);

      list = ['a', 'b'];
      trimStartIfNeeded(list, 1);
      expect(list, ['b']);

      list = ['a', 'b', 'c'];
      trimStartIfNeeded(list, 1);
      expect(list, ['c']);

      list = ['a'];
      trimStartIfNeeded(list, 3);
      expect(list, ['a']);

      list = ['a', 'b', 'c'];
      trimStartIfNeeded(list, 3);
      expect(list, ['a', 'b', 'c']);

      list = ['a', 'b', 'c', 'd'];
      trimStartIfNeeded(list, 3);
      expect(list, ['b', 'c', 'd']);
    });
  });
}
