import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:monarch_annotations/monarch_annotations.dart';

import 'builder_helper.dart';

const TypeChecker monarchThemeTypeChecker =
    TypeChecker.fromRuntime(MonarchTheme);

class MetaThemesGenerator extends Generator {
  @override
  String? generate(LibraryReader library, BuildStep buildStep) {
    final annotations = library.annotatedWith(monarchThemeTypeChecker);
    if (annotations.isEmpty) {
      return null;
    }

    final expressions = <String>[];

    void addExpression(AnnotatedElement annotatedElement) {
      var annotation = annotatedElement.annotation;
      var element = annotatedElement.element;

      var themeName = annotation.read('name').stringValue;
      var isDefault = annotation.read('isDefault').boolValue;
      var themeVariableName = element.name;
      expressions
          .add("MetaTheme.user('$themeName', $themeVariableName, $isDefault)");
    }

    String proposedChangeMessage(Element element) => '''
Proposed change:
```
@MonarchTheme(...)
ThemeData get ${element.name} => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/themes''';

    for (var annotatedElement in annotations) {
      final element = annotatedElement.element;

      if (element is TopLevelVariableElement) {
        log.warning('''
$monarchWarningBegin
Consider changing top-level variable `${element.name}` to a getter. Hot reloading works better with 
top-level getters. 

${proposedChangeMessage(element)}
$monarchWarningEnd
''');

        addExpression(annotatedElement);
        continue;
      }

      if (element is PropertyAccessorElement && element.isGetter) {
        log.fine('Found MonarchTheme annotation on getter: ${element.name}');
        addExpression(annotatedElement);
        continue;
      }

      log.warning('''
$monarchWarningBegin
`@MonarchTheme` annotation on element `${element.name}` will not be used. The `@MonarchTheme` 
annotation should be placed on a top-level (or library) getter.

${proposedChangeMessage(element)}
$monarchWarningEnd
''');
    }

    var pathToThemeFile = getImportUriOrRelativePath(buildStep.inputId);

    return _outputContents(pathToThemeFile, expressions);
  }

  String _outputContents(
      String pathToThemeFile, List<String> metaThemeExpressions) {
    return '''
import 'package:monarch/monarch.dart';
import '$pathToThemeFile';

List<MetaTheme> get metaThemeItems => [
  ${metaThemeExpressions.join(', ')}
];

''';
  }
}
