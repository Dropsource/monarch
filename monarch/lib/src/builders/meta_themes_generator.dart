import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:monarch_annotations/monarch_annotations.dart';

import 'builder_helper.dart';

const TypeChecker monarchThemeTypeChecker =
    TypeChecker.fromRuntime(MonarchTheme);

class MetaThemesGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final annotations = library.annotatedWith(monarchThemeTypeChecker);
    if (annotations.isEmpty) {
      return null;
    }

    final expressions = <String>[];

    for (var annotatedElement in annotations) {
      final element = annotatedElement.element;

      if (element is TopLevelVariableElement) {
        log.fine(
            'Found MonarchTheme annotation on top-level element: ${element.name}');
        final annotation = annotatedElement.annotation;

        final themeName = annotation.read('name').stringValue;
        final isDefault = annotation.read('isDefault').boolValue;
        final themeVariableName = element.name;

        expressions.add("MetaTheme.user('$themeName', $themeVariableName, $isDefault)");
      } else {
        final msg = '''
Found MonarchTheme annotation on an element that is not a top-level variable.
The MonarchTheme annotation must be placed on a top-level variable.
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
import 'package:monarch/monarch.dart';
import '$pathToThemeFile';

final metaThemeItems = [
  ${metaThemeExpressions.join(', ')}
];

''';
  }
}
