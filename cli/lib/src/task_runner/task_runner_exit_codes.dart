import '../utils/cli_exit_code.dart';

class TaskRunnerExitCodes {
  static const generateStoriesFailed =
      CliExitCode(107, 'Stories source code generation failed', true);

  static const generateStoriesTerminated = CliExitCode(
      108, 'Stories source code generation terminated (CTRL+C)', false);

  static const buildPreviewBundleFailed =
      CliExitCode(109, 'Building preview bundle failed', true);

  static const buildPreviewBundleTerminated =
      CliExitCode(110, 'Building preview bundle terminated (CTRL+C)', false);

  static const monarchAppTerminated =
      CliExitCode(111, 'Monarch app terminated (CMD+Q or ALT+F4)', false);

  static const taskRunnerCliTerminated =
      CliExitCode(112, 'Task runner CLI terminated (CTRL+C)', false);

  static const projectConfigNotValid =
      CliExitCode(113, 'Project configuration is not valid', false);

  static const environmentConfigNotValid =
      CliExitCode(114, 'Environment configuration is not valid', false);

  static const copyIcuDataFileFailed = CliExitCode(
      115, 'Error copying resource file to .monarch directory', true);

  static const observatoryUriNotScraped = CliExitCode(
      116, 'Could not scrape Observatory URI from the log stream', true);

  static const compatibilityNotValid = CliExitCode(
      117, 'Compatibility is not valid', false);
}
