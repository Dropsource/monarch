import 'package:monarch_utils/log.dart';

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

    final compatibility =
        MonarchPackageCompatibility(projectConfig.flutterSdkId.version);

    log.info(
        'monarch_package_minimum_compatible_version=${compatibility.monarchPackageMinimumCompatibleVersion}');

    if (!compatibility
        .isMonarchPackageCompatible(projectConfig.monarchPackageVersion)) {
      errors.add(
          'The monarch package version your project is using is not compatible '
          'with this version of the Monarch CLI. ${compatibility.incompatibilityMessage}');
    }

    return errors;
  }

  @override
  String get foundErrorsMessage => 'Found compatibility errors';
}
