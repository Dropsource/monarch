@TestOn('windows')

import 'package:test/test.dart';

import 'package:monarch_io_utils/monarch_io_utils.dart';

void main() {
  group('platform_utils on Windows', () {
    test('valueForPlatform', () {
      expect(valueForPlatform(macos: 'foo', windows: 'bar'), 'bar');
      expect(valueForPlatform(macos: 1, windows: 2), 2);
      expect(valueForPlatform(macos: true, windows: false), false);
      expect(valueForPlatform(macos: ['a', 'b', 'c'], windows: ['x', 'y', 'z']),
          ['x', 'y', 'z']);
    });

    test('functionForPlatform', () {
      // when function returns a string
      expect(
          functionForPlatform(macos: () => 'foo', windows: () => 'bar'), 'bar');

      // when function returns void
      var i = 0;
      functionForPlatform(macos: () {
        i++;
      }, windows: () {
        i--;
      });
      expect(i, -1);

      // when function returns an explicit bool
      var flag =
          functionForPlatform<bool>(macos: () => true, windows: () => false);
      expect(flag, isFalse);
    });

    test('futureForPlatform', () async {
      var value = await futureForPlatform(
          macos: () => Future.value(1), windows: () => Future.value(2));
      expect(value, 2);
    });
  });
}
