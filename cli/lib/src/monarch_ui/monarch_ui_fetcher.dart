import 'dart:io';

import 'package:monarch_utils/log.dart';
import 'package:path/path.dart' as p;
import 'package:monarch_io_utils/utils.dart';
import 'package:meta/meta.dart';

import '../utils/cli_exit_code.dart';
import '../utils/managed_process.dart';
import '../utils/standard_output.dart';
import '../config/monarch_binaries.dart';
import '../version_api/ui_bundle.dart';
import '../version_api/version_api.dart';
import 'monarch_ui_fetch_exit_codes.dart';

/// Fetches monarch ui bundles into the bin/cache/monarch_ui directory.
/// It performs several tasks:
/// - Get ui_bundle info from version api
/// - Download ui_bundle zip from cdn
/// - Unzip
class MonarchUiFetcher extends LongRunningCli<CliExitCode> with Log {
  final StandardOutput stdout_;
  final MonarchBinaries monarchBinaries;
  final String binariesVersionNumber;

  /// The project's flutter id
  final FlutterSdkId id;

  final String userDeviceId;

  Downloader? _downloader;
  Unzipper? _unzipper;

  MonarchUiFetcher(
      {required this.stdout_,
      required this.monarchBinaries,
      required this.binariesVersionNumber,
      required this.id,
      required this.userDeviceId});

  @override
  void didRun() async {
    stdout_.writeln();

    stdout_.writeln('''
Downloading the Monarch UI for this project's flutter version...
''');

    var api = getVersionApi(userDeviceId);
    UiBundle uiBundle;
    try {
      uiBundle = await _getUiBundle(api);
      //
    } on ResourceNotFoundException {
      try {
        var upgradeInfo = await api.getUpgradeInfo(
            Platform.operatingSystem, binariesVersionNumber);
        //
        if (upgradeInfo.shouldUpgrade) {
          stdout_.writeln('''
We could not find a compatible Monarch UI for this version of Monarch and Flutter. 
However, there is a new version of Monarch which may be compatible.

Please run `monarch upgrade` and try again.''');
          return finish(MonarchUiFetchExitCodes.uiBundleNotFoundCanUpgrade);
          //
        } else {
          stdout_.writeln('''
We could not find a compatible Monarch UI for this version of Monarch and Flutter.
You could try switching Flutter versions. Or, create a GitHub issue in the Monarch repo 
and let us know which Flutter version your project is using: 
https://github.com/Dropsource/monarch/issues''');
          return finish(MonarchUiFetchExitCodes.uiBundleNotFoundCannotUpgrade);
          //
        }
      } on ResourceNotFoundException {
        stdout_.writeln(ResourceNotFoundException.userMessage(
            alternateCommand: 'monarch run -v'));
        return finish(MonarchUiFetchExitCodes.getUpgradeInfoError);
        //
      } on HttpRequestException {
        stdout_.writeln(HttpRequestException.userMessage);
        return finish(MonarchUiFetchExitCodes.getUpgradeInfoError);
        //
      } on JsonProcessingException {
        stdout_.writeln(JsonProcessingException.userMessage(
            alternateCommand: 'monarch run -v'));
        return finish(MonarchUiFetchExitCodes.getUpgradeInfoError);
        //
      } on ResponseNonSuccessfulException {
        stdout_.writeln(ResponseNonSuccessfulException.userMessage(
            alternateCommand: 'monarch run -v'));
        return finish(MonarchUiFetchExitCodes.getUpgradeInfoError);
        //
      }
      //
    } on HttpRequestException {
      stdout_.writeln(HttpRequestException.userMessage);
      return finish(MonarchUiFetchExitCodes.getUiBundleInfoError);
      //
    } on JsonProcessingException {
      stdout_.writeln(JsonProcessingException.userMessage(
          alternateCommand: 'monarch run -v'));
      return finish(MonarchUiFetchExitCodes.getUiBundleInfoError);
      //
    } on ResponseNonSuccessfulException {
      stdout_.writeln(ResponseNonSuccessfulException.userMessage(
          alternateCommand: 'monarch run -v'));
      return finish(MonarchUiFetchExitCodes.getUiBundleInfoError);
      //
    }

    try {
      if (!await monarchBinaries.monarchUiDirectory.exists()) {
        await monarchBinaries.monarchUiDirectory.create(recursive: true);
      }
    } catch (e, s) {
      log.warning(
          'Could not create (or check exists) the monarch ui directory', e, s);
      stdout_.writeln('Error creating monarch_ui directory');
      stdout_.writeln('At path: ${monarchBinaries.monarchUiDirectory.path}');
      stdout_.writeln(e.toString());
    }

    try {
      _downloader = getDownloader(uiBundle.uiBundleUrl);
      await _downloader!.start();
      await _downloader!.done();
    } on ProcessTerminatedException {
      stdout_.writeln('Download terminated.');
      return finish(CliExitCodes.userTerminated);
    } on ProcessFailedException {
      stdout_.writeln(
          'Error downloading Monarch UI bundle. Please check your internet connection and try again.');
      return finish(MonarchUiFetchExitCodes.downloadError);
    }

    try {
      stdout_.writeln();
      stdout_.write('Extracting Monarch UI zip... ');
      var zipFileName = _getZipFileName(uiBundle);
      _unzipper = getUnzipper(zipFileName);

      await _unzipper!.start();
      await _unzipper!.done();

      stdout_.writeln('Done.');
    } on ProcessTerminatedException {
      stdout_.writeln('Extracting zip terminated.');
      return finish(CliExitCodes.userTerminated);
    } on ProcessFailedException {
      stdout_.writeln('Error extracting Monarch UI zip.');
      return finish(MonarchUiFetchExitCodes.unzipError);
    }

    try {
      var zipFileName = _getZipFileName(uiBundle);
      var zipFilePath =
          p.join(monarchBinaries.monarchUiDirectory.path, zipFileName);
      var zipFile = File(zipFilePath);
      await delete(zipFile);
      log.fine('monarch ui zip deleted: $zipFilePath');
    } catch (e, s) {
      log.warning('Could not delete monarch ui zip file', e, s);
    }

    if (id.channel == FlutterChannels.unknown) {
      try {
        await renameDownloadedUiAsUnknown(uiBundle);
        log.fine('downloaded ui directory renamed to unknown channel id');
      } catch (e, s) {
        log.warning(
            'Could not rename downloaded ui directory to unknown channel id directory',
            e,
            s);
        stdout_.writeln('Error renaming downloaded ui directory');
        stdout_.writeln(e.toString());
        return finish(MonarchUiFetchExitCodes.renameUiDirError);
      }
    }

    return finish(MonarchUiFetchExitCodes.success);
  }

  Future<UiBundle> _getUiBundle(VersionApi api) {
    if (id.channel == FlutterChannels.unknown) {
      return _getUiBundleForUnknownChannel(api);
    } else {
      return api.getUiBundle(
          operatingSystem: Platform.operatingSystem,
          versionNumber: binariesVersionNumber,
          flutterVersion: id.version,
          flutterChannel: id.channel);
    }
  }

  Future<UiBundle> _getUiBundleForUnknownChannel(VersionApi api) async {
    var knownChannels = [
      FlutterChannels.stable,
      FlutterChannels.beta,
      FlutterChannels.dev
    ];
    for (var knownChannel in knownChannels) {
      try {
        var uiBundle = await api.getUiBundle(
            operatingSystem: Platform.operatingSystem,
            versionNumber: binariesVersionNumber,
            flutterVersion: id.version,
            flutterChannel: knownChannel);
        log.info(
            'Flutter channel is unknown, found flutter ${id.version} in $knownChannel channel');
        return uiBundle;
      } on ResourceNotFoundException {
        log.warning(
            'Flutter channel is unknown, did not find flutter ${id.version} in $knownChannel channel');
      }
    }
    log.warning(
        'Flutter channel is unknown, did not find flutter ${id.version} in any known channel');
    throw ResourceNotFoundException();
  }

  @protected
  VersionApi getVersionApi(String userDeviceId) =>
      VersionApi(readUserId: userDeviceId);

  @protected
  Downloader getDownloader(String uiBundleUrl) => Downloader(
      downloadUrl: uiBundleUrl,
      destinationDirectory: monarchBinaries.monarchUiDirectory);

  @protected
  Unzipper getUnzipper(String zipFileName) => Unzipper(
      zipFileName: zipFileName,
      zipFileParentDirectory: monarchBinaries.monarchUiDirectory);

  @protected
  Future<void> renameDownloadedUiAsUnknown(UiBundle uiBundle) async {
    var downloadedId = FlutterSdkId(
        channel: uiBundle.flutterChannel,
        version: uiBundle.flutterVersion,
        operatingSystem: uiBundle.operatingSystem);

    var downloadedUiIdDir = monarchBinaries.uiIdDirectory(downloadedId);
    var unknownUiIdDir = monarchBinaries.uiIdDirectory(id);
    log.fine('renaming ${downloadedUiIdDir.path} to ${unknownUiIdDir.path}');

    await downloadedUiIdDir.rename(unknownUiIdDir.path);
  }

  @protected
  Future<void> delete(File zipFile) => zipFile.delete();

  String _getZipFileName(UiBundle uiBundle) {
    var pathContext = p.Context(style: p.Style.url);
    return pathContext.basename(uiBundle.uiBundleUrl);
  }

  @override
  CliExitCode get userTerminatedExitCode => CliExitCodes.userTerminated;

  @override
  Future<void> willTerminate() async {
    _downloader?.terminate();
    _unzipper?.terminate();
  }
}
