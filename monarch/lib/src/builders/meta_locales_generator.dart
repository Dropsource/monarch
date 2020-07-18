import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:monarch_annotations/monarch_annotations.dart';

import 'builder_helper.dart';

const TypeChecker monarchLocalizationTypeChecker =
    TypeChecker.fromRuntime(MonarchLocalization);

class MetaLocalizationsGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final annotations = library.annotatedWith(monarchLocalizationTypeChecker);
    if (annotations.isEmpty) {
      return null;
    }

    final expressions = <String>[];

    for (var annotatedElement in annotations) {
      final element = annotatedElement.element;

      if (element is ClassElement) {
        log.fine(
            'Found MonarchLocalization annotation on class element: ${element.name}');
        final annotation = annotatedElement.annotation;

        final localesDartObjects = annotation.read('locales').listValue;
        final localeCodes = localesDartObjects.map((x) => x.toStringValue());
        final locales = localeCodes.map((x) => "Locale('$x')");
        final localesExpression = "[${locales.join(', ')}]";

        expressions.add(
            "MetaLocalization.user($localesExpression, ${element.name}(), '${element.name}')");
      } else {
        final msg = '''
Found MonarchLocalization annotation on an element that is not a class declaration.
The MonarchLocalization annotation must be placed on a class declaration.
Element name: ${element.name}
''';
        log.warning(msg);
      }
    }

    final pathToLocalizationFile =
        getRelativePathFromOutputToInput(buildStep.inputId);

    return _outputContents(pathToLocalizationFile, expressions);
  }

  String _outputContents(
      String pathToLocalizationFile, List<String> metaLocalizationExpressions) {
    return '''
import 'dart:ui';
import 'package:monarch/monarch.dart';
import '$pathToLocalizationFile';

final metaLocalizationItems = [
  ${metaLocalizationExpressions.join(', ')}
];

''';
  }
}
