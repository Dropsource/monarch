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

class FlutterPackageHelper {
  final String flutterPackageRootPath;
  FlutterPackageHelper(this.flutterPackageRootPath);

  bool get endsWithTrailingDirs =>
      flutterPackageRootPath.endsWith(p.joinAll(trailingDirs));

  List<String> trailingDirs = ['packages', 'flutter'];

  String getExecutablePath() {
    final parts = p.split(flutterPackageRootPath);
    parts.removeRange(parts.length - trailingDirs.length, parts.length);
    return p.join(p.joinAll(parts), 'bin', 'flutter');
  }
}
