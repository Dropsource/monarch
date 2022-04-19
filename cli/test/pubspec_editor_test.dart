import 'package:monarch_cli/src/init/pubspec_editor.dart';
import 'package:test/test.dart';

const dev_dependencies = 'dev_dependencies';

const dev_dependencies_missing = '''
name: foo

dependencies:
  a: 0.1.0
  flutter:
    sdk: flutter
''';
const dev_dependencies_empty = '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
''';
const dev_dependencies_with_package_x = '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  x: ^0.0.1
''';
const dev_dependencies_without_package_x = '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  y: ^1.1.1
''';

void main() {
  group('PubspecEditor tests', () {
    PubspecEditor editor;

    group('sets package and its version', () {
      test('when dev_dependencies is missing', () {
        editor = PubspecEditor(dev_dependencies_missing);
        editor.setPackage(dev_dependencies, 'x', '^0.0.2');

        expect(editor.newContents, '''
name: foo

dependencies:
  a: 0.1.0
  flutter:
    sdk: flutter
dev_dependencies:
  x: ^0.0.2
''');
      });

      test('when dev_dependencies is empty', () {
        editor = PubspecEditor(dev_dependencies_empty);
        editor.setPackage(dev_dependencies, 'x', '^0.0.3');

        expect(editor.newContents, '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies: 
  x: ^0.0.3
''');
      });

      test('when dev_dependencies has package to set', () {
        editor = PubspecEditor(dev_dependencies_with_package_x);
        editor.setPackage(dev_dependencies, 'x', '^0.0.5');

        expect(editor.newContents, '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  x: ^0.0.5
''');
      });

      test('when dev_dependencies does not have package to set', () {
        editor = PubspecEditor(dev_dependencies_without_package_x);
        editor.setPackage(dev_dependencies, 'x', '^0.0.6');

        expect(editor.newContents, '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  x: ^0.0.6
  y: ^1.1.1
''');
      });
    });
  });
}
