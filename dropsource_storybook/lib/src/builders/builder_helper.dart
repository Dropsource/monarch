import 'package:build/build.dart';
// import 'package:build_runner_core/build_runner_core.dart';
import 'package:path/path.dart' as p;

const generatedOutputDirectory = '.dart_tool/build/generated';

String getOuputPathInGeneratedOutputDirectory(AssetId inputId) {
  return '$generatedOutputDirectory/${inputId.package}/${p.dirname(inputId.path)}';
}

String getRelativePathFromOutputToInput(AssetId inputId) {
  final outputPath = getOuputPathInGeneratedOutputDirectory(inputId);
  return p.relative(inputId.path, from: outputPath);
}