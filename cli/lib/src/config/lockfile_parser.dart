import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart' as pub;
import 'package:yaml/yaml.dart';

class LockfileParser {
  final Directory projectDirectory;
  final List<String> packagesOfInterest;

  File get pubspecLockFile =>
      File(p.join(projectDirectory.path, 'pubspec.lock'));

  LockfileParser(this.projectDirectory, this.packagesOfInterest);

  final packagesMap = <String, PackageInfo>{};

  Future<void> parseAndPopulatePackagesMap() async {
    var contents = await pubspecLockFile.readAsString();
    var dependencies = loadYaml(contents) as YamlMap;
    packagesMap.clear();
    for (String packageName in dependencies['packages'].keys) {
      if (packagesOfInterest.contains(packageName)) {
        var version = dependencies['packages'][packageName]['version'];
        packagesMap[packageName] =
            PackageInfo(packageName, pub.Version.parse(version));
      }
    }
  }
}

class PackageInfo {
  final String name;
  final pub.Version version;

  PackageInfo(this.name, this.version);
}
