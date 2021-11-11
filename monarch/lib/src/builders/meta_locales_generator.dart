import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:monarch_annotations/monarch_annotations.dart';

import 'builder_helper.dart';

const TypeChecker monarchLocalizationsTypeChecker =
    TypeChecker.fromRuntime(MonarchLocalizations);

class MetaLocalizationsGenerator extends Generator {
  @override
  String? generate(LibraryReader library, BuildStep buildStep) {
    final annotations = library.annotatedWith(monarchLocalizationsTypeChecker);
    if (annotations.isEmpty) {
      return null;
    }

    final expressions = <String>[];

    void addExpression(AnnotatedElement annotatedElement) {
      var annotation = annotatedElement.annotation;
      var element = annotatedElement.element;

      var localesDartObjects = annotation.read('locales').listValue;
      var locales = localesDartObjects.map((x) {
        var languageCode = x.getField('languageCode')!.toStringValue();
        var countryCode = x.getField('countryCode')!.toStringValue();
        if (countryCode == null) {
          return "Locale('$languageCode')";
        } else {
          return "Locale('$languageCode', '$countryCode')";
        }
      });
      var localesExpression = "[${locales.join(', ')}]";

      expressions.add(
          "MetaLocalization.user($localesExpression, ${element.name}, '${element.name}')");
    }

    String proposedChangeMessage(VariableElement element) => '''
Proposed change:
```
@MonarchLocalizations(...)
${element.type.getDisplayString(withNullability: false)} get ${element.name} => ...
```

After you make the change, run `monarch run` again.
Documentation: https://monarchapp.io/docs/internationalization''';

    for (var annotatedElement in annotations) {
      final element = annotatedElement.element;
      if (element is TopLevelVariableElement) {
        if (!element.isConst) {
          log.warning('''
$monarchWarningBegin
Consider changing top-level variable `${element.name}` to a getter or const. Hot reloading works better 
with top-level getters or const variables. 

${proposedChangeMessage(element)}
$monarchWarningEnd
''');
        }

        addExpression(annotatedElement);
        continue;
      }

      if (element is PropertyAccessorElement && element.isGetter) {
        log.fine('Found MonarchLocalizations on getter: ${element.name}');
        addExpression(annotatedElement);
        continue;
      }

      log.warning('''
$monarchWarningBegin
`@MonarchLocalizations` annotation on element `${element.name}` will not be used. 
The `@MonarchLocalizations` annotation should be placed on a top-level getter or const.
$monarchWarningEnd
''');
    }

    if (isInLib(buildStep.inputId)) {
      return _outputContents(buildStep.inputId.uri.toString(), expressions);
    } else {
      // Could not compute import URI to file with MonarchLocalizations annotation
      // outside of lib directory.
      log.warning('''
$monarchWarningBegin
`@MonarchLocalizations` annotation on library ${buildStep.inputId.path} will not be used.
The `@MonarchLocalizations` annotation should be used in libraries inside the lib directory.
$monarchWarningEnd
''');
      return null;
    }
  }

  String _outputContents(String pathToLocalizationsFile,
      List<String> metaLocalizationExpressions) {
    return '''
import 'dart:ui';
import 'package:monarch/monarch.dart';
import '$pathToLocalizationsFile';

List<MetaLocalization> get metaLocalizationItems => [
  ${metaLocalizationExpressions.join(', ')}
];

''';
  }
}
