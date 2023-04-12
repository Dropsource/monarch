import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';

import 'builder_helper.dart';

const metaStoriesExtension = '.meta_stories.g.dart';

class MetaStoriesBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': [metaStoriesExtension]
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.fine('Processing ${buildStep.inputId}');

    var storiesNames = <String>[];
    var storiesMap = <String, String>{};

    var unit = await buildStep.resolver
        .compilationUnitFor(buildStep.inputId, allowSyntaxErrors: true);

    for (var declaration in unit.declarations) {
      if (declaration is! FunctionDeclaration) {
        log.fine(
            'Skipping: declaration is not a FunctionDeclaration, it is a ${declaration.runtimeType}.');
        continue;
      }

      var functionName = declaration.name.lexeme;
      var returnType = declaration.returnType;
      var parameters = declaration.functionExpression.parameters;

      if (Identifier.isPrivateName(functionName)) {
        log.fine('Skipping: function `$functionName` is private.');
        continue;
      }

      if (returnType == null) {
        log.fine(
            'Skipping: function `$functionName` does not have a return type.');
        continue;
      }

      if (returnType is! NamedType) {
        log.fine(
            'Skipping: the return type of function `$functionName` is not a NamedType, it is a ${returnType.runtimeType}.');
        continue;
      }

      if (parameters == null) {
        log.fine(
            'Skipping: function `$functionName` has null parameters, it must be a getter.');
        continue;
      }

      if (parameters.parameters.isNotEmpty) {
        log.fine(
            'Skipping: function `$functionName` has parameters, story functions should have zero parameters.');
        continue;
      }

      /// Potential story function found. It is a potential story because we are not
      /// resolving the return type element, which would be expensive. Since we are
      /// not resolving the return type element, then we cannot check if it is of type Widget.
      /// Instead, we will do a runtime check in [ProjectDataManager.load].

      var returnTypeName = returnType.name.name;
      var storyName = functionName;
      var storyNameInSingleQuotes = "'$storyName'";
      log.fine('Found potential story `$returnTypeName $storyName()`.');

      storiesNames.add(storyNameInSingleQuotes);
      storiesMap[storyNameInSingleQuotes] = storyName;
    }

    final pathToStoriesFile = getImportUriOrRelativePath(buildStep.inputId);
    final output = _outputContents(
        pathToStoriesFile, buildStep.inputId, storiesNames, storiesMap);

    var outputId = buildStep.inputId.changeExtension(metaStoriesExtension);

    await buildStep.writeAsString(outputId, output);
  }

  String _outputContents(String pathToStoriesFile, AssetId storiesAssetId,
      List<String> storiesNames, Map<String, String> storiesMap) {
    return '''
${generatedCodeHeader('MetaStoriesBuilder')}

import 'package:monarch/monarch.dart';
import '$pathToStoriesFile';

MetaStories get metaStories => MetaStories.user('${storiesAssetId.package}', '${storiesAssetId.path}', [${storiesNames.join(', ')}], $storiesMap);

''';
  }
}
