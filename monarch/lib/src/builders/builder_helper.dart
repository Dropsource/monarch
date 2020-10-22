import 'package:build/build.dart';
// import 'package:build_runner_core/build_runner_core.dart';
import 'package:path/path.dart' as p;

String generatedOutputDirectory = p.join('.dart_tool','build','generated');

String getOuputPathInGeneratedOutputDirectory(AssetId inputId) {
  return p.join(generatedOutputDirectory, inputId.package, p.dirname(inputId.path));
}

String getRelativePathFromOutputToInput(AssetId inputId) {
  final outputPath = getOuputPathInGeneratedOutputDirectory(inputId);
  return normalizeAssetPath(p.relative(inputId.path, from: outputPath));
}

/// Asset paths always have forward slashes regardless of platform.
String normalizeAssetPath(String path) => path.replaceAll(r'\', '/');
