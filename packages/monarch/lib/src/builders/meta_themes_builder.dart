import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:monarch_annotations/monarch_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'builder_helper.dart';

const metaThemesExtension = '.meta_themes.g.dart';

class MetaThemesBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': [metaThemesExtension]
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    /// @GOTCHA: Optimization:
    /// This is a quick-and-rough way to check for the presence of an annotation.
    /// The proper way is to resolve the compilation unit. However, that is
    /// slow to do on every file in the user's project.
    var contents = await buildStep.readAsString(buildStep.inputId);
    if (!contents.contains('@MonarchTheme')) {
      return;
    }

    /// Calling `resolver.libraryFor` is expensive.
    /// Therefore, we are only calling it on dart libraries that we suspect
    /// have a monarch annotation.
    var libraryElement = await buildStep.resolver
        .libraryFor(buildStep.inputId, allowSyntaxErrors: true);
    var library = LibraryReader(libraryElement);
    var monarchThemeTypeChecker = TypeChecker.typeNamed(MonarchTheme);

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

      if (element is GetterElement) {
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

    var output = _outputContents(pathToThemeFile, expressions);
    var outputId = buildStep.inputId.changeExtension(metaThemesExtension);

    await buildStep.writeAsString(outputId, output);
  }

  String _outputContents(
      String pathToThemeFile, List<String> metaThemeExpressions) {
    return '''
${generatedCodeHeader('MetaThemesBuilder')}

import 'package:monarch/monarch.dart';
import '$pathToThemeFile';

List<MetaTheme> get metaThemeItems => [
  ${metaThemeExpressions.join(', ')}
];

''';
  }
}
