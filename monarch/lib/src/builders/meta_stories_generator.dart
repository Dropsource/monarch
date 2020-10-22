import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

import 'builder_helper.dart';

const TypeChecker widgetTypeChecker =
    TypeChecker.fromUrl('package:flutter/src/widgets/framework.dart#Widget');

class MetaStoriesGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final inputId = buildStep.inputId;

    if (!inputId.path.endsWith('_stories.dart')) {
      return null;
    }

    log.fine('Processing: ${buildStep.inputId}');

    var storiesNames = <String>[];
    var storiesMap = <String, String>{};

    for (var topLevelElement in library.allElements) {
      if (topLevelElement is FunctionElement) {
        if (topLevelElement.returnType != null &&
            topLevelElement.returnType.element != null) {
          if (widgetTypeChecker.isExactly(topLevelElement.returnType.element)) {
            // if (topLevelElement.returnType.element.name == 'Widget') {
            final storyName = topLevelElement.name;
            final storyNameInSingleQuotes = "'$storyName'";
            log.fine('Found story: $storyName');
            storiesNames.add(storyNameInSingleQuotes);
            storiesMap[storyNameInSingleQuotes] = storyName;
          } else {
            log.fine(
                'Top level function is not story, return type is not Widget: ${topLevelElement.name}');
          }
        } else {
          log.fine(
              'Could not get return type of top level function, skipping: ${topLevelElement.name}');
        }
      } else {
        log.fine(
            'Top level element is not story, it is not FunctionElement: ${topLevelElement.name}');
      }
    }

    final pathToStoriesFile = getRelativePathFromOutputToInput(inputId);

    final output =
        _outputContents(pathToStoriesFile, inputId, storiesNames, storiesMap);
    return output;
  }

  String _outputContents(String pathToStoriesFile, AssetId storiesAssetId,
      List<String> storiesNames, Map<String, String> storiesMap) {
    return '''
import 'package:monarch/monarch.dart';
import r'$pathToStoriesFile';

const metaStories = MetaStories('${storiesAssetId.package}', '${storiesAssetId.path}', [${storiesNames.join(', ')}], $storiesMap);

''';
  }
}
