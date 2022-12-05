@TestOn('windows')

import 'package:test/test.dart';
import 'package:monarch_cli/src/upgrade/upgrade_validator.dart';

void main() {
  List<String> validate(String path) =>
      UpgradeValidator.validateMonarchExecutablePath(path);
  group('validates monarch executable path', () {
    test('bin placed at root', () {
      {
        var errors = validate(r'C:\bin\monarch.exe');
        expect(errors, [
          r'Expected to find path monarch\bin\monarch.exe, instead found C:\bin\monarch.exe'
        ]);
      }

      {
        var errors = validate(r'bin\monarch.exe');
        expect(errors, [
          r'Expected to find path monarch\bin\monarch.exe, instead found bin\monarch.exe'
        ]);
      }
    });

    test('bin placed at user directory', () {
      {
        var errors = validate(r'C:\Users\joe\bin\monarch.exe');
        expect(errors, [
          r'Expected to find path monarch\bin\monarch.exe, instead found joe\bin\monarch.exe'
        ]);
      }
      {
        var errors = validate(r'C:\Program Files\bin\monarch.exe');
        expect(errors, [
          r'Expected to find path monarch\bin\monarch.exe, instead found Program Files\bin\monarch.exe'
        ]);
      }
    });

    test('edge cases', () {
      {
        var errors = validate(r'C:\monarch.exe');
        expect(errors, [
          r'Expected to find path monarch\bin\monarch.exe, instead found C:\monarch.exe'
        ]);
      }

      {
        var errors = validate(r'C:');
        expect(errors, [
          r'Expected to find path monarch\bin\monarch.exe, instead found C:'
        ]);
      }
    });

    test('monarch path ok', () {
      {
        var errors =
            validate(r'C:\Users\joe\development\monarch\bin\monarch.exe');
        expect(errors, isEmpty);
      }

      {
        var errors = validate(r'C:\Users\joe\foo\monarch\bin\monarch.exe');
        expect(errors, isEmpty);
      }
    });

    test('monarch exe changed', () {
      {
        var errors =
            validate(r'C:\Users\joe\development\monarch\bin\momo.exe');
        expect(errors, [
          r'Expected to find path monarch\bin\monarch.exe, instead found monarch\bin\momo.exe'
        ]);
      }
    });

    test('bin changed', () {
      {
        var errors =
            validate(r'C:\Users\joe\development\monarch\binz\momo.exe');
        expect(errors, [
          r'Expected to find path monarch\bin\monarch.exe, instead found monarch\binz\momo.exe'
        ]);
      }
    });
  });
}
