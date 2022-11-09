import '../utils/cli_exit_code.dart';

class InitExitCodes {
  static const success = CliExitCode(0, 'Init successful', false);

  static const projectConfigNotValid =
      CliExitCode(131, 'Project configuration is not valid', false);

  static const someErrors =
      CliExitCode(132, 'At least one error during initialization', true);
}
