import 'package:build/build.dart';
// import 'package:build_runner_core/build_runner_core.dart';
import 'package:path/path.dart' as p;

String generatedOutputDirectory = p.join('.dart_tool', 'build', 'generated');

String getOuputPathInGeneratedOutputDirectory(AssetId inputId) {
  return p.join(
      generatedOutputDirectory, inputId.package, p.dirname(inputId.path));
}

/// Returns true if the given asset id is in the lib directory of its package.
///
/// Logic taken from `package:build`:
/// file: build-2.0.0/lib/src/asset/id.dart
/// function: _constructUri
bool isInLib(AssetId id) => id.pathSegments.first == 'lib';

String getImportUriOrRelativePath(AssetId inputId) {
  if (isInLib(inputId)) {
    return inputId.uri.toString();
  } else {
    return getRelativePathFromOutputToInput(inputId);
  }
}

String getRelativePathFromOutputToInput(AssetId inputId) {
  final outputPath = getOuputPathInGeneratedOutputDirectory(inputId);
  return normalizeAssetPath(p.relative(inputId.path, from: outputPath));
}

/// Asset paths always have forward slashes regardless of platform.
String normalizeAssetPath(String path) => path.replaceAll(r'\', '/');
