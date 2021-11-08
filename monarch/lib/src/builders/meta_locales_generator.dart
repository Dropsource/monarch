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

    for (var annotatedElement in annotations) {
      final element = annotatedElement.element;
      if (element is TopLevelVariableElement || element is PropertyAccessorElement) {
        log.fine(
            'Found MonarchLocalizations annotation on top-level variable or getter: ${element.name}');
        final annotation = annotatedElement.annotation;

        final localesDartObjects = annotation.read('locales').listValue;
        final locales = localesDartObjects.map((x) {
          final languageCode = x.getField('languageCode')!.toStringValue();
          final countryCode = x.getField('countryCode')!.toStringValue();
          if (countryCode == null) {
            return "Locale('$languageCode')";
          } else {
            return "Locale('$languageCode', '$countryCode')";
          }
        });
        final localesExpression = "[${locales.join(', ')}]";

        expressions.add(
            "MetaLocalization.user($localesExpression, ${element.name}, '${element.name}')");
      } else {
        final msg = '''
Found MonarchLocalizations annotation on an element that is not a top-level variable or getter.
The MonarchLocalizations annotation must be placed on a top-level variable.
Element name: ${element.name}
''';
        log.warning(msg);
      }
    }

    if (isInLib(buildStep.inputId)) {
      return _outputContents(buildStep.inputId.uri.toString(), expressions);
    } else {
      log.warning(
          'Could not compute import URI to file with MonarchLocalizations annotation. '
          'Please make sure the file is inside the lib directory.');
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
