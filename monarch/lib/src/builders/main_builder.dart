import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;

import 'builder_helper.dart';

class MainBuilder implements Builder {
  final BuilderOptions options;

  MainBuilder(this.options);

  bool get noSoundNullSafety =>
      options.config.containsKey('no-sound-null-safety');

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'$lib$': ['main_monarch.g.dart']
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.fine('Processing ${buildStep.inputId}');

    final metaLocalizationsIdMap = await _getLibraryPrefixToAssetIdMap(
        buildStep, 'l', '***/*.meta_localizations.g.dart');

    final metaThemesIdMap = await _getLibraryPrefixToAssetIdMap(
        buildStep, 't', '**/*.meta_themes.g.dart');

    final metaStoriesIdMap = await _getLibraryPrefixToAssetIdMap(
        buildStep, 's', '**/*.meta_stories.g.dart');

    final outputId =
        AssetId(buildStep.inputId.package, 'lib/main_monarch.g.dart');

    final output = _outputContents(
        buildStep.inputId.package,
        _getImportStatements(metaLocalizationsIdMap),
        _getImportStatements(metaThemesIdMap),
        _getImportStatements(metaStoriesIdMap),
        _getMetaItemsStatements(
            metaLocalizationsIdMap, 'metaLocalizationItems'),
        _getMetaItemsStatements(metaThemesIdMap, 'metaThemeItems'),
        _getMetaStoriesMap(metaStoriesIdMap));

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
      final targetPath = item.value.path;

      final relativePath =
          normalizeAssetPath(p.relative(targetPath, from: 'lib'));
      return "import r'$relativePath' as $libraryPrefix;";
    });
  }

  // Iterable<String> _getMetaThemeStatements(Map<String, AssetId> map) {
  //   return map.entries.map((item) {
  //     final libraryPrefix = item.key;
  //     return '...$libraryPrefix.metaThemeItems';
  //   });
  // }

  Iterable<String> _getMetaItemsStatements(
      Map<String, AssetId> map, String metaItemsTopVariableName) {
    return map.entries.map((item) {
      final libraryPrefix = item.key;
      return '...$libraryPrefix.$metaItemsTopVariableName';
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
      Iterable<String> metaLocalizationsImportStatements,
      Iterable<String> metaThemesImportStatements,
      Iterable<String> metaStoriesImportStatements,
      Iterable<String> metaLocalizationList,
      Iterable<String> metaThemeList,
      Map<String, String> metaStoriesMap) {
    return '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MainBuilder - monarch
// **************************************************************************

${noSoundNullSafety ? '// @dart=2.9' : ''}

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:monarch/monarch.dart';

${metaLocalizationsImportStatements.join('\n')}

${metaThemesImportStatements.join('\n')}

${metaStoriesImportStatements.join('\n')}

void main() {
  startMonarch('$packageName', [${metaLocalizationList.join(', ')}], [${metaThemeList.join(', ')}], $metaStoriesMap);
}

''';
  }
}
