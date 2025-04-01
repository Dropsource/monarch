// ignore_for_file: non_constant_identifier_names

import 'package:pub_semver/pub_semver.dart' as pub;

final monarchPackage_2_1 = pub.Version(2, 1, 0);
final monarchPackage_2_2 = pub.Version(2, 2, 0);
final monarchPackage_3_0 = pub.Version(3, 0, 0);
final monarchPackage_3_9 = pub.Version(3, 9, 2);

final buildRunnerPackage2 = pub.Version(2, 1, 11);

class MonarchPackageCompatibility {
  final pub.Version flutterVersion;

  MonarchPackageCompatibility(String flutterVersionText)
      : flutterVersion = pub.Version.parse(flutterVersionText);

  /// Oldest version of package:monarch that this version of the CLI is compatible
  /// with.
  ///
  /// @GOTCHA: when you change this version, make sure to run the test
  /// test/monarch_package_compatibility_test.dart
  /// and change it as needed to test for the new version boundaries
  pub.Version get monarchPackageMinimumCompatibleVersion =>
      monarchPackage_3_9;

  /// Version of package:monarch that `monarch init` uses.
  ///
  /// [monarchPackageInitVersion] and [monarchPackageMinimumCompatibleVersion] may
  /// be different. The init version is what we want new projects to use, which
  /// is usually the latest version. The minimum compatible version is the oldest
  /// version of package:monarch that this version of the CLI is compatible with.
  pub.Version get monarchPackageInitVersion => monarchPackage_3_9;

  /// Version of package:build_runner that `monarch init` uses.
  pub.Version get buildRunnerPackageInitVersion => buildRunnerPackage2;

  bool isMonarchPackageCompatible(pub.Version monarchPackageVersion) {
    return monarchPackageVersion >= monarchPackageMinimumCompatibleVersion;
  }

  String get incompatibilityMessage =>
      'Use monarch package version ^$monarchPackageMinimumCompatibleVersion or greater.';
}
