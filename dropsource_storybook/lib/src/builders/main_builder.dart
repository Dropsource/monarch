import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:dart_style/dart_style.dart';

class MainBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
        r'$lib$': ['main_storybook.g.dart']
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.fine('Processing ${buildStep.inputId}');

    final metaThemesMap = await _getLibraryPrefixToAssetIdMap(
        buildStep, 't', '**/*.meta_themes.g.dart');

    final metaStoriesMap = await _getLibraryPrefixToAssetIdMap(
        buildStep, 's', '**/*.meta_stories.g.dart');

    final outputId =
        AssetId(buildStep.inputId.package, 'lib/main_storybook.g.dart');

    final output = _outputContents(
        buildStep.inputId.package,
        _getImportStatements(metaThemesMap),
        _getImportStatements(metaStoriesMap),
        _getMetaThemeStatements(metaThemesMap),
        _getMetaStoriesMap(metaStoriesMap));

    var formatter = DartFormatter();
    var formattedOutput = formatter.format(output);

    await buildStep.writeAsString(outputId, formattedOutput);
  }

  /// Returns a map that maps a unique library prefix to an AssetId.
  Future<Map<String, AssetId>> _getLibraryPrefixToAssetIdMap(
      BuildStep buildStep, String prefixToken, String globPattern) async {
    final assetIdMap = <String, AssetId>{};

    var index = 0;
    await for (final _assetId in buildStep.findAssets(Glob(globPattern))) {
      final libraryPrefix = '$prefixToken$index';
      assetIdMap[libraryPrefix] = _assetId;
      index++;
    }

    return assetIdMap;
  }

  Iterable<String> _getImportStatements(Map<String, AssetId> map) {
    return map.entries.map((item) {
      final libraryPrefix = item.key;
      return "import '../${item.value.path}' as $libraryPrefix;";
    });
  }

  Iterable<String> _getMetaThemeStatements(Map<String, AssetId> map) {
    return map.entries.map((item) {
      final libraryPrefix = item.key;
      return '...$libraryPrefix.metaThemeItems';
    });
  }

  Map<String, String> _getMetaStoriesMap(Map<String, AssetId> map) {
    final _map = <String, String>{};
    for (var item in map.entries) {
      final libraryPrefix = item.key;
      final assetId = item.value;
      final key = "'${assetId.package}|${assetId.path}'";
      _map[key] = '$libraryPrefix.metaStories';
    }
    return _map;
  }

  String _outputContents(
      String packageName,
      Iterable<String> metaThemesImportStatements,
      Iterable<String> metaStoriesImportStatements,
      Iterable<String> metaThemeList,
      Map<String, String> metaStoriesMap) {
    return '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MainBuilder - dropsource_storybook
// **************************************************************************

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:dropsource_storybook/dropsource_storybook.dart';

${metaThemesImportStatements.join('\n')}

${metaStoriesImportStatements.join('\n')}

void main() {
  ui.window.setIsolateDebugName('storybook-isolate');
  startStorybook('$packageName', [${metaThemeList.join(', ')}], $metaStoriesMap);
}

''';
  }
}
