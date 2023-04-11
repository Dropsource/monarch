import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';

import 'builder_helper.dart';

class MetaStoriesBuilder implements Builder {

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.fine('Processing ${buildStep.inputId}');

    var storiesNames = <String>[];
    var storiesMap = <String, String>{};

    var resolver = buildStep.resolver;
    var unit = await resolver.compilationUnitFor(buildStep.inputId, allowSyntaxErrors: true);
    
    for (var declaration in unit.declarations) {
      if (declaration is! FunctionDeclaration) {
        log.fine('Skipping: declaration is not a FunctionDeclaration, it is a ${declaration.runtimeType}.');
        continue;
      }

      var functionName = declaration.name.lexeme;
      var returnType = declaration.returnType;
      var parameters = declaration.functionExpression.parameters;

      if (returnType == null) {
        log.fine('Skipping: function `$functionName` does not have a return type.');
        continue;
      }

      if (returnType is! NamedType) {
        log.fine('Skipping: the return type of function `$functionName` is not a NamedType, it is a ${returnType.runtimeType}.');
        continue;
      }

      if (parameters == null) {
        log.fine('Skipping: function `$functionName` has null parameters, it must be a getter.');
        continue;
      }

      if (parameters.parameters.isNotEmpty) {
        log.fine('Skipping: function `$functionName` has parameters, story functions should have zero parameters.');
        continue;
      }

      /// Potential story function found. It is a potential story because we are not 
      /// resolving the return type element, which would be expensive. Since we are 
      /// not resolving the return type element, then we cannot check it is of type Widget.
      /// Instead, we will do a runtime check in [ProjectDataManager.load].

      var returnTypeName = returnType.name.name;
      var storyName = functionName;
      var storyNameInSingleQuotes = "'$storyName'";
      log.fine('Found potential story `$returnTypeName $storyName()`.');

      storiesNames.add(storyNameInSingleQuotes);
      storiesMap[storyNameInSingleQuotes] = storyName;


      // if (declaration is FunctionDeclaration) {
      //   if (declaration.returnType != null) {
      //     var returnType = declaration.returnType;
      //     if (returnType is NamedType) {
      //       var returnTypeName = returnType.name.name;
      //       var storyName = declaration.name.lexeme;
      //       var storyNameInSingleQuotes = "'$storyName'";
      //       log.fine('Found potential story: $storyName');

      //       if (returnType.name.name == 'Widget') { // TODO: confirm this is ok, is there a better way to compare against 'Widget'?
      //         var storyName = declaration.name.lexeme;
      //         var storyNameInSingleQuotes = "'$storyName'";
      //         log.fine('Found story: $storyName');
      //         storiesNames.add(storyNameInSingleQuotes);
      //         storiesMap[storyNameInSingleQuotes] = storyName;
      //       }
      //       else {
      //         log.fine('declaration return type is ${returnType.name.name}');
      //       }
      //     }
      //     else {
      //       log.fine('declaration return type runtime type is ${returnType.runtimeType}');
      //     }
      //   }
      //   else {
      //     log.fine('declaration return type is null');
      //   }
      // }
      // else {
      //   log.fine('declartion runtime type is ${declaration.runtimeType}');
      // }
    }

    final pathToStoriesFile = getImportUriOrRelativePath(buildStep.inputId);
    final output =
        _outputContents(pathToStoriesFile, buildStep.inputId, storiesNames, storiesMap);

    var outputId = buildStep.inputId.changeExtension('.meta_stories.g.dart');

    await buildStep.writeAsString(outputId, output);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': ['.meta_stories.g.dart']
      };

  String _outputContents(String pathToStoriesFile, AssetId storiesAssetId,
      List<String> storiesNames, Map<String, String> storiesMap) {
    return '''
import 'package:monarch/monarch.dart';
import '$pathToStoriesFile';

MetaStories get metaStories => MetaStories('${storiesAssetId.package}', '${storiesAssetId.path}', [${storiesNames.join(', ')}], $storiesMap);

''';
  }
}