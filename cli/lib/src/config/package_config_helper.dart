import 'dart:io';

import 'package:monarch_utils/log.dart';
import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as p;

class PackageConfigHelper with Log {
  final Directory projectDirectory;
  late final PackageConfig? packageConfig;

  PackageConfigHelper(this.projectDirectory);

  Future<void> setUp() async {
    packageConfig = await findPackageConfig(projectDirectory, recurse: false,
        onError: (err) {
      _hasParsingError = true;
      log.severe('Error parsing package_config.json', err);
    });
  }

  bool get packageConfigExists => packageConfig != null;
  bool _hasParsingError = false;
  bool get hasParsingError => _hasParsingError;

  bool hasPackage(String packageName) =>
      packageConfig!.packages.any((element) => element.name == packageName);

  String getPackageRootPath(String packageName) {
    var package = packageConfig!.packages
        .firstWhere((element) => element.name == packageName);
    var path = package.root.toFilePath(windows: Platform.isWindows);
    if (path.endsWith(p.separator)) {
      return path.substring(0, path.length - 1);
    } else {
      return path;
    }
  }
}

/// Computes the flutter exe and dart exe paths given the 
/// "flutter" package rootUri path in .dart_tool/package_config.json
/// 
/// It expects the "flutter" package path to be like:
///   file:///path/to/some-flutter-sdk/packages/flutter"
/// 
/// It then assumes that the flutter exe and dart exe will be at:
///   /path/to/some-flutter-sdk/bin/flutter
///   /path/to/some-flutter-sdk/bin/dart 
class FlutterPackageHelper {
  final String flutterPackageRootPath;
  FlutterPackageHelper(this.flutterPackageRootPath);

  bool get endsWithTrailingDirs =>
      flutterPackageRootPath.endsWith(p.joinAll(trailingDirs));

  List<String> trailingDirs = ['packages', 'flutter'];

  String getFlutterSdkPath() {
    final parts = p.split(flutterPackageRootPath);
    parts.removeRange(parts.length - trailingDirs.length, parts.length);
    return p.joinAll(parts);
  }

  String getFlutterExePath() => p.join(getFlutterSdkPath(), 'bin', 'flutter');
  
  String getDartExePath() => p.join(getFlutterSdkPath(), 'bin', 'dart');
}
