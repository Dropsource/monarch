import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:dropsource_storybook_annotations/dropsource_storybook_annotations.dart';

import 'builder_helper.dart';

const TypeChecker storybookThemeTypeChecker =
    TypeChecker.fromRuntime(StorybookTheme);

class MetaThemesGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final annotations = library.annotatedWith(storybookThemeTypeChecker);
    if (annotations.isEmpty) {
      return null;
    }

    final expressions = <String>[];

    for (var annotatedElement in annotations) {
      final element = annotatedElement.element;

      if (element is TopLevelVariableElement) {
        log.fine(
            'Found StorybookTheme annotation on top-level element: ${element.name}');
        final annotation = annotatedElement.annotation;

        final themeName = annotation.read('name').stringValue;
        final isDefault = annotation.read('isDefault').boolValue;
        final themeVariableName = element.name;

        expressions.add("MetaTheme.user('$themeName', $themeVariableName, $isDefault)");
      } else {
        final msg = '''
Found StorybookTheme annotation on an element that is not a top-level variable.
The StorybookTheme annotation must be placed on a top-level variable.
Element name: ${element.name}
''';
        log.warning(msg);
      }
    }

    final pathToThemeFile = getRelativePathFromOutputToInput(buildStep.inputId);

    return _outputContents(pathToThemeFile, expressions);
  }

  String _outputContents(
      String pathToThemeFile, List<String> metaThemeExpressions) {
    return '''
import 'package:dropsource_storybook/dropsource_storybook.dart';
import '$pathToThemeFile';

final metaThemeItems = [
  ${metaThemeExpressions.join(', ')}
];

''';
  }
}
