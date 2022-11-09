import '../utils/cli_exit_code.dart';

class MonarchUiFetchExitCodes {
  static const success = CliExitCode(0, 'Monarch UI fetch successful', false);

  static const getUiBundleInfoError =
      CliExitCode(141, 'Get ui bundle info error', true);

  static const uiBundleNotFound =
      CliExitCode(142, 'Monarch UI bundle not found', false);

  static const downloadError =
      CliExitCode(143, 'Monarch UI bundle download error', true);

  static const unzipError =
      CliExitCode(144, 'Error extracting Monarch UI bundle', true);

  static const uiBundleNotFoundCanUpgrade =
      CliExitCode(145, 'Monarch UI bundle not found - able to upgrade', false);

  static const uiBundleNotFoundCannotUpgrade = CliExitCode(
      146, 'Monarch UI bundle not found - unable to upgrade', false);

  static const getUpgradeInfoError =
      CliExitCode(147, 'Get upgrade info error', true);

  static const renameUiDirError =
      CliExitCode(148, 'Rename UI directory error', true);

  static const flutterVersionNotSupported =
      CliExitCode(149, 'Project flutter version not supported', false);
}
