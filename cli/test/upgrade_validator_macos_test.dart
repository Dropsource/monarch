@TestOn('mac-os')

import 'package:test/test.dart';
import 'package:monarch_cli/src/upgrade/upgrade_validator.dart';

void main() {
  List<String> _validate(String path) =>
      UpgradeValidator.validateMonarchExecutablePath(path);
  group('validates monarch executable path', () {
    test('bin placed at root', () {
      {
        var errors = _validate('/bin/monarch');
        expect(errors, [
          'Expected to find path monarch/bin/monarch, instead found /bin/monarch'
        ]);
      }

      {
        var errors = _validate('bin/monarch');
        expect(errors, [
          'Expected to find path monarch/bin/monarch, instead found bin/monarch'
        ]);
      }
    });

    test('bin placed at user directory', () {
      {
        var errors = _validate('/Users/joe/bin/monarch');
        expect(errors, [
          'Expected to find path monarch/bin/monarch, instead found joe/bin/monarch'
        ]);
      }
      {
        var errors = _validate('~/bin/monarch');
        expect(errors, [
          'Expected to find path monarch/bin/monarch, instead found ~/bin/monarch'
        ]);
      }
    });

    test('edge cases', () {
      {
        var errors = _validate('monarch');
        expect(errors, [
          'Expected to find path monarch/bin/monarch, instead found monarch'
        ]);
      }

      {
        var errors = _validate('');
        expect(errors, [
          'Expected to find path monarch/bin/monarch, instead found '
        ]);
      }
    });

    test('monarch path ok', () {
      {
        var errors = _validate('/Users/joe/development/monarch/bin/monarch');
        expect(errors, isEmpty);
      }

      {
        var errors = _validate('/Users/joe/foo/monarch/bin/monarch');
        expect(errors, isEmpty);
      }
    });

    test('monarch exe changed', () {
      {
        var errors = _validate(r'/Users/joe/development/monarch/bin/momo');
         expect(errors, [
          r'Expected to find path monarch/bin/monarch, instead found monarch/bin/momo'
        ]);
      }
    });

    test('bin changed', () {
      {
        var errors = _validate(r'/Users/joe/development/monarch/binz/momo');
         expect(errors, [
          r'Expected to find path monarch/bin/monarch, instead found monarch/binz/momo'
        ]);
      }
    });
  });
}
