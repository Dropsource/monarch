import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:dropsource_storybook_annotations/dropsource_storybook_annotations.dart';

const TypeChecker storybookThemeTypeChecker =
    TypeChecker.fromRuntime(StorybookTheme);

class ThemesGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final annotations = library.annotatedWith(storybookThemeTypeChecker);
    if (annotations.isEmpty) {
      return null;
    }

    final themeDataExpressions = <String>[];

    for (var annotatedElement in annotations) {
      final element = annotatedElement.element;

      if (element is TopLevelVariableElement) {
        log.fine('Found StorybookTheme annotation on top-level element: ${element.name}');
        final annotation = annotatedElement.annotation;

        final themeName = annotation.read('name').stringValue;
        final isDefault = annotation.read('isDefault').boolValue;
        final themeVariableName = element.name;

        themeDataExpressions.add(_getThemeDataExpression(themeName, themeVariableName, isDefault));

      } else {
        final msg = '''
Found StorybookTheme annotation on an element that is not a top-level variable.
The StorybookTheme annotation must be placed on a top-level variable.
Element name: ${element.name}
''';
        log.warning(msg);
      }
    }

    return _outputContents(buildStep.inputId, themeDataExpressions);
  }

  String _getThemeDataExpression(String themeName, String themeVariableName, bool isDefault) {
    return "ThemeMetaData('$themeName', $themeVariableName, $isDefault)";
  }

  String _outputContents(AssetId libraryAssetId,
      List<String> themeDataExpressions) {
    return '''
import 'package:dropsource_storybook/dropsource_storybook.dart';
import '${libraryAssetId.uri}';

const themeMetaDataItems = [
  ${themeDataExpressions.join(', ')}
];

''';
  }
}
