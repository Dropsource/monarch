import '../utils/cli_exit_code.dart';

class UpgradeExitCodes {
  static const success = CliExitCode(0, 'Upgrade successful', false);

  static const partialSuccess =
      CliExitCode(0, 'Upgrade partially successful', false);

  static const getLatestVersionError =
      CliExitCode(121, 'Get latest version error', true);

  static const downloadError =
      CliExitCode(122, 'Installation bundle download error', true);

  static const unzipError =
      CliExitCode(123, 'Error extracting installation bundle', true);

  static const deleteError =
      CliExitCode(124, 'Error deleting pre-existing Monarch binaries', true);

  static const copyError =
      CliExitCode(125, 'Error copying new Monarch binaries', true);

  static const getVersionForUpgradeError =
      CliExitCode(126, 'Get version for upgrade error', true);

  static const validationError = 
      CliExitCode(127, 'Upgrade validation error', false);
}
