import 'dart:io';
import 'package:monarch_cli/src/config/context_info.dart';
import 'package:path/path.dart' as p;
import 'package:monarch_utils/log.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';

import '../config/monarch_binaries.dart';
import '../utils/cli_exit_code.dart';
import '../utils/standard_output.dart';
import '../utils/managed_process.dart';
import '../version_api/version.dart';
import '../version_api/version_api.dart';
import 'upgrade_exit_codes.dart';
import 'upgrade_validator.dart';

class Upgrader extends LongRunningCli<CliExitCode> with Log {
  final MonarchBinaries monarchBinaries;
  final VersionApi versionApi;
  final String operatingSystem;
  final ContextInfo contextInfo;

  Upgrader(this.monarchBinaries, this.versionApi, this.operatingSystem,
      this.contextInfo);

  Version? _upgradeVersion;
  Version? get latestVersion => _upgradeVersion;

  @override
  void didRun() {
    _upgrade();
  }

  @override
  CliExitCode get userTerminatedExitCode => CliExitCodes.userTerminated;

  @override
  Future<void> willTerminate() async {
    _downloader?.terminate();
    _unzipper?.terminate();
  }

  Downloader? _downloader;
  Unzipper? _unzipper;

  void _upgrade() async {
    final monarchDirectory = monarchBinaries.monarchDirectory;

    stdout_default.writeln('## Upgrading Monarch');

    stdout_default.writeln('Validating previous Monarch installation.');

    var validator = UpgradeValidator(monarchBinaries);
    await validator.validate();

    if (!validator.isValid) {
      stdout_default.writeln();
      stdout_default.writeln(validator.validationErrorsPretty());
      stdout_default.writeln();
      stdout_default.writeln('''
To get the latest version of Monarch go to the website and install it as if it 
was a fresh install: https://monarchapp.io/docs/install.
''');
      return finish(UpgradeExitCodes.validationError);
    }

    stdout_default.writeln(
        'New Monarch version will be installed in ${monarchDirectory.path}');

    try {
      _upgradeVersion =
          await versionApi.getVersionForUpgrade(contextInfo.toPropertiesMap());
      //
    } on ResourceNotFoundException {
      stdout_default.writeln(ResourceNotFoundException.userMessage(
          alternateCommand: 'monarch upgrade -v'));
      return finish(UpgradeExitCodes.getVersionForUpgradeError);
      //
    } on HttpRequestException {
      stdout_default.writeln(HttpRequestException.userMessage);
      return finish(UpgradeExitCodes.getVersionForUpgradeError);
      //
    } on JsonProcessingException {
      stdout_default.writeln(JsonProcessingException.userMessage(
          alternateCommand: 'monarch upgrade -v'));
      return finish(UpgradeExitCodes.getVersionForUpgradeError);
      //
    } on ResponseNonSuccessfulException {
      stdout_default.writeln(ResponseNonSuccessfulException.userMessage(
          alternateCommand: 'monarch upgrade -v'));
      return finish(UpgradeExitCodes.getVersionForUpgradeError);
      //
    }

    final tempDir = Directory.systemTemp.createTempSync('monarch_upgrade_');
    log.info('Using temp directory ${tempDir.path}');

    try {
      stdout_default.writeln();
      stdout_default.writeln(
          'Downloading Monarch installation bundle version ${_upgradeVersion!.versionNumber}');
      stdout_default.writeln();
      await _downloadInstallationBundle(
          _upgradeVersion!.installationBundleUrl, tempDir);
    } on ProcessTerminatedException {
      stdout_default.writeln('\nUpgrade terminated.');
      return finish(CliExitCodes.userTerminated);
    } on ProcessFailedException {
      if (Platform.isLinux) {
        var result = await Process.run('which', ['curl']);
        if (result.exitCode == 0 && result.stdout.toString().contains('snap')) {
          stdout_default.writeln();
          stdout_default.writeln('''
You are using _snap_ curl which has known issues. Please use _apt_ curl instead.
See https://askubuntu.com/a/1387286

Alternatively, you can re-install Monarch: https://monarchapp.io/docs/install
''');
          return finish(UpgradeExitCodes.downloadError);
        }
      }

      stdout_default.writeln(
          'Error downloading Monarch installation bundle. Please try `monarch upgrade` again.');
      return finish(UpgradeExitCodes.downloadError);
    }

    try {
      stdout_default.writeln();
      stdout_default.writeln('Extracting installation bundle.');
      await _extractInstallationBundle(
          _upgradeVersion!.installationBundleUrl, tempDir);
    } on ProcessTerminatedException {
      stdout_default.writeln('\nUpgrade terminated.');
      return finish(CliExitCodes.userTerminated);
    } on ProcessFailedException {
      stdout_default.writeln(
          'Error extracting installation bundle. Please try `monarch upgrade` again.');
      return finish(UpgradeExitCodes.unzipError);
    }

    try {
      final oldDir =
          Directory.systemTemp.createTempSync('monarch_old_binaries_');
      log.info('Temp directory for old monarch binaries ${oldDir.path}');
      stdout_default.writeln('Moving old Monarch binaries to ${oldDir.path}');
      await _moveOldMonarchBinaries(oldDir);
    } on UpgradeCommandException {
      stdout_default.writeln(
          'Error moving old Monarch binaries. Monarch may need to be re-installed.');
      return finish(UpgradeExitCodes.deleteError);
    }

    try {
      stdout_default.writeln('Copying new Monarch binaries.');
      await _copyNewMonarchBinaries(tempDir);
    } on UpgradeCommandException {
      stdout_default.writeln(
          'Error copying new Monarch binaries. Monarch may need to be re-installed.');
      return finish(UpgradeExitCodes.copyError);
    }

    stdout_default.writeln();
    stdout_default.writeln(
        'Monarch upgraded to version ${_upgradeVersion!.versionNumber}');
    return finish(UpgradeExitCodes.success);
  }

  Future<void> _downloadInstallationBundle(
      String installationBundleUrl, Directory tempDir) async {
    _downloader = Downloader(
        downloadUrl: installationBundleUrl, destinationDirectory: tempDir);
    await _downloader!.start();
    await _downloader!.done();
  }

  Future<void> _extractInstallationBundle(
      String installationBundleUrl, Directory tempDir) async {
    final pathContext = p.Context(style: p.Style.url);
    final zipFileName = pathContext.basename(installationBundleUrl);

    _unzipper =
        Unzipper(zipFileName: zipFileName, zipFileParentDirectory: tempDir);
    await _unzipper!.start();
    await _unzipper!.done();
  }

  Future<void> _moveOldMonarchBinaries(Directory oldDir) async {
    try {
      await _moveDirectoryContents(monarchBinaries.monarchDirectory, oldDir);
    } catch (e) {
      throw UpgradeCommandException();
    }
    log.fine('Old monarch binaries moved ok');
  }

  Future<void> _copyNewMonarchBinaries(Directory tempDir) async {
    try {
      final extractedMonarchDirectory =
          Directory(p.join(tempDir.path, 'monarch'));

      await _moveDirectoryContents(
          extractedMonarchDirectory, monarchBinaries.monarchDirectory);
    } catch (e) {
      throw UpgradeCommandException();
    }
  }

  Future<void> _moveDirectoryContents(
      Directory sourceDir, Directory destinationDir) async {
    final sourceContents = sourceDir.listSync();

    for (var sourceDirectoryOrFile in sourceContents) {
      final destinationPath =
          p.join(destinationDir.path, p.basename(sourceDirectoryOrFile.path));
      try {
        await sourceDirectoryOrFile.rename(destinationPath);
        log.fine(
            'Moved (renamed) ${sourceDirectoryOrFile.path} --> $destinationPath');
      } catch (e, s) {
        log.severe(
            'Error while moving (renaming) ${sourceDirectoryOrFile.path} --> $destinationPath',
            e,
            s);
        rethrow;
      }
    }
  }
}

class UpgradeCommandException implements Exception {}
