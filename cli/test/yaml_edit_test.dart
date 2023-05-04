import 'package:yaml_edit/yaml_edit.dart';
import 'package:test/test.dart';
import 'package:yaml_edit/src/errors.dart';
import 'package:yaml/yaml.dart';

/// A matcher for functions that throw [PathError].
Matcher throwsPathError = throwsA(isA<PathError>());

void main() {
  group('set package in dev_dependencies', () {
    group('with populated dev_dependencies node', () {
      test('without dev_dependencies.monarch node', () async {
        var pubspec = '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
      ''';

        final doc = YamlEditor(pubspec);
        final devDependenciesNode = doc
            .parseAt(['dev_dependencies'], orElse: () => wrapAsYamlNode(null));
        expect(devDependenciesNode, isNotNull);
        expect(devDependenciesNode is YamlMap, isTrue);
        doc.update(['dev_dependencies', 'monarch'], '^0.0.1');

        expect(doc.toString(), '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  monarch: ^0.0.1

flutter:
      ''');
      });

      test('with dev_dependencies.monarch node', () async {
        var pubspec = '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  monarch: ^0.0.1
  flutter_test:
    sdk: flutter

flutter:
      ''';

        final doc = YamlEditor(pubspec);
        final monarchNode = doc.parseAt(['dev_dependencies', 'monarch'],
            orElse: () => wrapAsYamlNode(null));
        expect(monarchNode, isNotNull);
        expect(monarchNode is YamlScalar, isTrue);
        doc.update(['dev_dependencies', 'monarch'], '^0.0.2');

        expect(doc.toString(), '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  monarch: ^0.0.2
  flutter_test:
    sdk: flutter

flutter:
      ''');
      });
    });

    group('without dev_dependencies node', () {
      test('throws path error if child node of dev_dependencies is accessed',
          () async {
        var pubspec = '''
name: foo

dependencies:
  flutter:
    sdk: flutter

flutter:
      ''';

        final doc = YamlEditor(pubspec);
        expect(() => doc.update(['dev_dependencies', 'monarch'], '^0.0.1'),
            throwsPathError);
      });

      test('sets monarch node', () async {
        var pubspec = '''
name: foo

dependencies:
  flutter:
    sdk: flutter

flutter:
      ''';

        final doc = YamlEditor(pubspec);
        final devDependenciesNode = doc
            .parseAt(['dev_dependencies'], orElse: () => wrapAsYamlNode(null));
        expect(devDependenciesNode.value, isNull);
        doc.update(['dev_dependencies'], {'monarch': '^0.0.3'});

        expect(doc.toString(), '''
name: foo

dependencies:
  flutter:
    sdk: flutter

flutter:
dev_dependencies:
  monarch: ^0.0.3
      ''');
      });
    });

    group('with empty dev_dependencies node', () {
      test('sets monarch node', () async {
        var pubspec = '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:

flutter:
      ''';

        final doc = YamlEditor(pubspec);
        final devDependenciesNode = doc
            .parseAt(['dev_dependencies'], orElse: () => wrapAsYamlNode(null));
        expect(devDependenciesNode, isNotNull);
        expect(devDependenciesNode is YamlScalar, isTrue);
        doc.update(['dev_dependencies'], {'monarch': '^0.0.4'});

        expect(doc.toString(), '''
name: foo

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  monarch: ^0.0.4

flutter:
      ''');

        final devDependenciesNode2 = doc
            .parseAt(['dev_dependencies'], orElse: () => wrapAsYamlNode(null));
        expect(devDependenciesNode2, isNotNull);
        expect(devDependenciesNode2 is YamlMap, isTrue);

        final monarchNode = doc.parseAt(['dev_dependencies', 'monarch'],
            orElse: () => wrapAsYamlNode(null));
        expect(monarchNode, isNotNull);
        expect(monarchNode is YamlScalar, isTrue);
      });
    });
  });
}
