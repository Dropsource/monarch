import 'package:monarch_utils/log.dart';

import '../utils/standard_output.dart';
import 'project_config.dart';
import 'enable_flutter_desktop.dart';
import 'validator.dart';

class EnvironmentMutations extends Validator with Log {
  final ProjectConfig config;

  final EnableFlutterDesktop enableFlutterDesktop;

  EnvironmentMutations(this.config)
      : enableFlutterDesktop = EnableFlutterDesktop(config);

  @override
  Future<void> validate() async {
    await _checkIfFlutterDesktopIsEnabled();
  }

  Future<void> _checkIfFlutterDesktopIsEnabled() async {
    var isEnabled = false;

    try {
      isEnabled = await enableFlutterDesktop.isEnabled();
    } catch (e, s) {
      log.warning('Error checking if flutter desktop is enabled', e, s);
      validationErrors.add('Could not check if flutter desktop is enabled');
    }

    if (isEnabled) {
      log.info('Flutter for desktop already enabled');
    }

    if (!isEnabled && isValid) {
      try {
        stdout_default.writeln('Enabling Flutter for desktop');
        await enableFlutterDesktop.enable();
      } catch (e, s) {
        log.warning('Error enabling flutter desktop', e, s);
        validationErrors.add('Could not enable Flutter desktop');
      }
    }
  }

  Future<void> tearDown() async {
    // we are leaving `--enable-macos-desktop` turned on
  }

  @override
  String get foundErrorsMessage => 'Found environment errors';
}
