import 'package:monarch_utils/log.dart';
import 'package:pub_semver/pub_semver.dart' as pub;

import 'monarch_package_compatibility.dart';
import 'project_config.dart';
import 'validator.dart';

class ProjectCompatibility extends Validator with Log {
  final TaskRunnerProjectConfig projectConfig;

  ProjectCompatibility(this.projectConfig);

  @override
  Future<void> validate() async {
    validationErrors.addAll(_validateMonarchPackageCompatibility());
  }

  List<String> _validateMonarchPackageCompatibility() {
    var errors = <String>[];

    if (pub.Version.parse(projectConfig.flutterSdkId.version) <
        pub.Version(3, 0, 0)) {
      errors.add('Flutter 2.x is not compatible with this version of Monarch. '
          'Please upgrade your Flutter SDK to 3.x. Or if you need to stay on Flutter 2.x, then '
          'please install Monarch 1.x (https://monarchapp.io/docs/install_flutter2x).');

      return errors;
    } else {
      var monarchPackageCompatibility =
          MonarchPackageCompatibility(projectConfig.flutterSdkId.version);

      log.info(
          'monarch_package_minimum_compatible_version=${monarchPackageCompatibility.monarchPackageMinimumCompatibleVersion}');

      if (!monarchPackageCompatibility
          .isMonarchPackageCompatible(projectConfig.monarchPackageVersion)) {
        errors.add(
            'The monarch package version your project is using is not compatible '
            'with this version of the Monarch CLI. ${monarchPackageCompatibility.incompatibilityMessage}');
      }

      return errors;
    }
  }

  @override
  String get foundErrorsMessage => 'Found compatibility errors';
}
