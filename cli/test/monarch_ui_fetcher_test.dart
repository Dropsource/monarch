import 'dart:io';

import 'package:monarch_cli/src/monarch_ui/monarch_ui_fetch_exit_codes.dart';
import 'package:monarch_cli/src/utils/cli_exit_code.dart';
import 'package:monarch_cli/src/utils/standard_output.dart';
import 'package:monarch_cli/src/version_api/ui_bundle.dart';
import 'package:monarch_cli/src/version_api/upgrade_info.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;

import 'monarch_ui_fetcher_test.mocks.dart';
import 'package:monarch_cli/src/config/monarch_binaries.dart';
import 'package:monarch_cli/src/utils/managed_process.dart';
import 'package:monarch_cli/src/version_api/version_api.dart';
import 'package:monarch_io_utils/utils.dart';
import 'package:monarch_cli/src/monarch_ui/monarch_ui_fetcher.dart';

import 'test_utils/test_stdout.dart';

@GenerateMocks([VersionApi, Downloader, Unzipper])
void main() {
  group('MonarchUiFetcher', () {
    late MonarchBinaries monarchBinaries;
    late TestStdout test_stdout;
    late TestFetcher fetcher;

    const v2_0_6 = '2.0.6';

    var versionNumber01 = '1.1.1-1.0.test';
    var id_2_0_6 = FlutterSdkId(
        channel: 'stable',
        version: v2_0_6,
        operatingSystem: Platform.operatingSystem);
    var userDeviceId01 = 'uid-01';
    var uiBundle01 = UiBundle(
        timestamp: DateTime.now(),
        versionNumber: versionNumber01,
        operatingSystem: Platform.operatingSystem,
        flutterVersion: id_2_0_6.version,
        flutterChannel: id_2_0_6.channel,
        uiBundleUrl: 'https://cdn.monarchapp.io/ui/ui_bundle_01.zip');

    var id_2_0_6_unknownChannel = FlutterSdkId(
        channel: 'unknown',
        version: id_2_0_6.version,
        operatingSystem: id_2_0_6.operatingSystem);

    MockVersionApi getMockGetUiBundleSuccess01() {
      var api = MockVersionApi();
      when(api.getUiBundle(
              operatingSystem: Platform.operatingSystem,
              versionNumber: versionNumber01,
              flutterVersion: id_2_0_6.version,
              flutterChannel: id_2_0_6.channel))
          .thenAnswer((_) async => uiBundle01);
      return api;
    }

    MockDownloader getMockDownloaderSuccess() {
      var downloader = MockDownloader();
      when(downloader.start()).thenAnswer((_) => Future.value());
      when(downloader.done()).thenAnswer((_) {
        test_stdout.writeln('[Downloader output would go here]');
        return Future.value();
      });
      return downloader;
    }

    MockUnzipper getMockUnzipperSuccess() {
      var unzipper = MockUnzipper();
      when(unzipper.start()).thenAnswer((_) => Future.value());
      when(unzipper.done()).thenAnswer((_) => Future.value());
      return unzipper;
    }

    TestFetcher getTestFetcher01() {
      return TestFetcher(
          stdout_: StandardOutput(test_stdout),
          monarchBinaries: monarchBinaries,
          binariesVersionNumber: versionNumber01,
          id: id_2_0_6,
          userDeviceId: userDeviceId01);
    }

    TestFetcher getTestFetcher01_unknownChannel() {
      return TestFetcher(
          stdout_: StandardOutput(test_stdout),
          monarchBinaries: monarchBinaries,
          binariesVersionNumber: versionNumber01,
          id: id_2_0_6_unknownChannel,
          userDeviceId: userDeviceId01);
    }

    Future<void> verifyFetcherExit(
        {required CliExitCode exitCode,
        bool? shouldUiDirExist,
        bool? isZipFileDeleted,
        required String output}) async {
      var _exitCode = await fetcher.exit;
      expect(_exitCode.code, exitCode.code);
      if (shouldUiDirExist != null) {
        expect(await monarchBinaries.monarchUiDirectory.exists(),
            shouldUiDirExist);
      }
      if (isZipFileDeleted != null) {
        expect(fetcher.zipFileDeleted, isZipFileDeleted);
      }
      expect(test_stdout.buffer.toString(), output);
    }

    setUp(() {
      monarchBinaries = createTempMonarchBinaries();
      test_stdout = TestStdout();
    });

    const successDoneOutput = '''

Downloading the Monarch UI for this project's flutter version...

[Downloader output would go here]

Extracting Monarch UI zip... Done.
''';

    group('success scenarios', () {
      setUp(() {
        fetcher = getTestFetcher01();

        fetcher.mockVersionApi = getMockGetUiBundleSuccess01();
        fetcher.mockDownloader = getMockDownloaderSuccess();
        fetcher.mockUnzipper = getMockUnzipperSuccess();
      });

      test('success output when monarch ui dir does not exist', () async {
        expect(await monarchBinaries.monarchUiDirectory.exists(), isFalse);

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.success,
            shouldUiDirExist: true,
            isZipFileDeleted: true,
            output: successDoneOutput);
      });

      test('success output when monarch ui dir exists', () async {
        await monarchBinaries.monarchUiDirectory.create(recursive: true);
        expect(await monarchBinaries.monarchUiDirectory.exists(), isTrue);

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.success,
            shouldUiDirExist: true,
            isZipFileDeleted: true,
            output: successDoneOutput);
      });

      test('success output when it fails to delete zip file', () async {
        fetcher.deleteFileException =
            Exception('some exception while deleting file');

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.success,
            shouldUiDirExist: true,
            isZipFileDeleted: false,
            output: successDoneOutput);
      });
    });

    group('unknown channel success', () {
      setUp(() {
        fetcher = getTestFetcher01_unknownChannel();

        fetcher.mockVersionApi = getMockGetUiBundleSuccess01();
        fetcher.mockDownloader = getMockDownloaderSuccess();
        fetcher.mockUnzipper = getMockUnzipperSuccess();
      });

      test('when channel is unknown it first tries stable', () async {
        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.success,
            shouldUiDirExist: true,
            isZipFileDeleted: true,
            output: successDoneOutput);
        verify(fetcher.mockVersionApi.getUiBundle(
            operatingSystem: Platform.operatingSystem,
            versionNumber: versionNumber01,
            flutterVersion: id_2_0_6.version,
            flutterChannel: 'stable'));
      });
    });

    group('unzip failed scenarios', () {
      late MockUnzipper unzipper;

      setUp(() {
        fetcher = getTestFetcher01();

        unzipper = MockUnzipper();
        when(unzipper.start()).thenAnswer((_) => Future.value());

        fetcher.mockVersionApi = getMockGetUiBundleSuccess01();
        fetcher.mockDownloader = getMockDownloaderSuccess();
        fetcher.mockUnzipper = unzipper;
      });

      test('output when unzip process fails', () async {
        when(unzipper.done())
            .thenAnswer((_) => Future.error(ProcessFailedException()));

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.unzipError,
            shouldUiDirExist: true,
            output: '''

Downloading the Monarch UI for this project's flutter version...

[Downloader output would go here]

Extracting Monarch UI zip... Error extracting Monarch UI zip.
''');
      });

      test('output when unzip process is terminatead', () async {
        when(unzipper.done())
            .thenAnswer((_) => Future.error(ProcessTerminatedException()));

        fetcher.run();

        await verifyFetcherExit(
            exitCode: CliExitCodes.userTerminated,
            shouldUiDirExist: true,
            output: '''

Downloading the Monarch UI for this project's flutter version...

[Downloader output would go here]

Extracting Monarch UI zip... Extracting zip terminated.
''');
      });
    });

    group('downloader failed scenarios', () {
      late MockDownloader downloader;

      setUp(() {
        fetcher = getTestFetcher01();

        downloader = MockDownloader();
        when(downloader.start()).thenAnswer((_) => Future.value());

        fetcher.mockVersionApi = getMockGetUiBundleSuccess01();
        fetcher.mockDownloader = downloader;
      });

      test('output when downloader process fails', () async {
        when(downloader.done()).thenAnswer((_) {
          test_stdout.writeln('[Downloader in progress]');
          return Future.error(ProcessFailedException());
        });

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.downloadError,
            shouldUiDirExist: true,
            output: '''

Downloading the Monarch UI for this project's flutter version...

[Downloader in progress]
Error downloading Monarch UI bundle. Please check your internet connection and try again.
''');
      });

      test('output when downloader process is terminatead', () async {
        when(downloader.done()).thenAnswer((_) {
          test_stdout.writeln('[Downloader in progress]');
          return Future.error(ProcessTerminatedException());
        });

        fetcher.run();

        await verifyFetcherExit(
            exitCode: CliExitCodes.userTerminated,
            shouldUiDirExist: true,
            output: '''

Downloading the Monarch UI for this project's flutter version...

[Downloader in progress]
Download terminated.
''');
      });
    });

    group('GET /ui_bundle exception scenarios', () {
      late MockVersionApi api;

      void setUpGetUiBundleException01(Exception ex) {
        when(api.getUiBundle(
                operatingSystem: Platform.operatingSystem,
                versionNumber: versionNumber01,
                flutterVersion: id_2_0_6.version,
                flutterChannel: id_2_0_6.channel))
            .thenAnswer((_) async => throw ex);
      }

      setUp(() {
        fetcher = getTestFetcher01();
        api = MockVersionApi();
        fetcher.mockVersionApi = api;
      });

      test('output when GET /ui_bundle response is non successful', () async {
        setUpGetUiBundleException01(ResponseNonSuccessfulException());

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.getUiBundleInfoError, output: '''

Downloading the Monarch UI for this project's flutter version...

Monarch API returned non-successful status code. Please try again or run `monarch run -v`.
''');
      });

      test('output when GET /ui_bundle response has json issues', () async {
        setUpGetUiBundleException01(JsonProcessingException());

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.getUiBundleInfoError, output: '''

Downloading the Monarch UI for this project's flutter version...

Error processing http response. Please try again or run `monarch run -v`.
''');
      });

      test('output when GET /ui_bundle request has http or network errors',
          () async {
        setUpGetUiBundleException01(HttpRequestException());

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.getUiBundleInfoError, output: '''

Downloading the Monarch UI for this project's flutter version...

Error while sending request to Monarch API. Please check your internet connection and try again.
''');
      });
    });

    group('when GET /ui_bundle returns resource not found', () {
      late MockVersionApi api;

      setUp(() {
        fetcher = getTestFetcher01();
        api = MockVersionApi();
        when(api.getUiBundle(
                operatingSystem: Platform.operatingSystem,
                versionNumber: versionNumber01,
                flutterVersion: id_2_0_6.version,
                flutterChannel: id_2_0_6.channel))
            .thenAnswer((_) async => throw ResourceNotFoundException());
        fetcher.mockVersionApi = api;
      });

      test('output when GET /upgrade_info returns shouldUpgrade == true',
          () async {
        when(api.getUpgradeInfo(Platform.operatingSystem, versionNumber01))
            .thenAnswer((_) async => UpgradeInfo(shouldUpgrade: true));

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.uiBundleNotFoundCanUpgrade,
            output: '''

Downloading the Monarch UI for this project's flutter version...

We could not find a compatible Monarch UI for this version of Monarch and Flutter. 
However, there is a new version of Monarch which may be compatible.

Please run `monarch upgrade` and try again.
''');
      });

      test('output when GET /upgrade_info returns shouldUpgrade == false',
          () async {
        when(api.getUpgradeInfo(Platform.operatingSystem, versionNumber01))
            .thenAnswer((_) async => UpgradeInfo(shouldUpgrade: false));

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.uiBundleNotFoundCannotUpgrade,
            output: '''

Downloading the Monarch UI for this project's flutter version...

We could not find a compatible Monarch UI for this version of Monarch and Flutter.
You could try switching Flutter versions. Or, create a GitHub issue in the Monarch repo 
and let us know which Flutter version your project is using: 
https://github.com/Dropsource/monarch/issues
''');
      });
    });

    group('when version in unknown channel is not found in any known channel',
        () {
      late MockVersionApi api;

      setUp(() {
        fetcher = getTestFetcher01_unknownChannel();
        api = MockVersionApi();
        for (var knownChannel in [
          FlutterChannels.stable,
          FlutterChannels.beta,
          FlutterChannels.dev
        ]) {
          when(api.getUiBundle(
                  operatingSystem: Platform.operatingSystem,
                  versionNumber: versionNumber01,
                  flutterVersion: id_2_0_6.version,
                  flutterChannel: knownChannel))
              .thenAnswer((_) async => throw ResourceNotFoundException());
        }
        fetcher.mockVersionApi = api;
      });

      test('returns not found afer trying every known channel', () async {
        when(api.getUpgradeInfo(Platform.operatingSystem, versionNumber01))
            .thenAnswer((_) async => UpgradeInfo(shouldUpgrade: false));

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.uiBundleNotFoundCannotUpgrade,
            output: '''

Downloading the Monarch UI for this project's flutter version...

We could not find a compatible Monarch UI for this version of Monarch and Flutter.
You could try switching Flutter versions. Or, create a GitHub issue in the Monarch repo 
and let us know which Flutter version your project is using: 
https://github.com/Dropsource/monarch/issues
''');

        verify(api.getUiBundle(
            operatingSystem: Platform.operatingSystem,
            versionNumber: versionNumber01,
            flutterVersion: id_2_0_6.version,
            flutterChannel: FlutterChannels.stable));
        verify(api.getUiBundle(
            operatingSystem: Platform.operatingSystem,
            versionNumber: versionNumber01,
            flutterVersion: id_2_0_6.version,
            flutterChannel: FlutterChannels.beta));
        verify(api.getUiBundle(
            operatingSystem: Platform.operatingSystem,
            versionNumber: versionNumber01,
            flutterVersion: id_2_0_6.version,
            flutterChannel: FlutterChannels.dev));
      });
    });

    group('GET /upgrade_info exception scenarios', () {
      late MockVersionApi api;

      void setUpGetUpgradeInfoException01(Exception ex) {
        when(api.getUpgradeInfo(Platform.operatingSystem, versionNumber01))
            .thenAnswer((_) async => throw ex);
      }

      setUp(() {
        fetcher = getTestFetcher01();
        api = MockVersionApi();
        when(api.getUiBundle(
                operatingSystem: Platform.operatingSystem,
                versionNumber: versionNumber01,
                flutterVersion: id_2_0_6.version,
                flutterChannel: id_2_0_6.channel))
            .thenAnswer((_) async => throw ResourceNotFoundException());
        fetcher.mockVersionApi = api;
      });

      test('output when GET /upgrade_info response is non successful',
          () async {
        setUpGetUpgradeInfoException01(ResponseNonSuccessfulException());

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.getUpgradeInfoError, output: '''

Downloading the Monarch UI for this project's flutter version...

Monarch API returned non-successful status code. Please try again or run `monarch run -v`.
''');
      });

      test('output when GET /upgrade_info response has json issues', () async {
        setUpGetUpgradeInfoException01(JsonProcessingException());

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.getUpgradeInfoError, output: '''

Downloading the Monarch UI for this project's flutter version...

Error processing http response. Please try again or run `monarch run -v`.
''');
      });

      test('output when GET /upgrade_info request has http or network errors',
          () async {
        setUpGetUpgradeInfoException01(HttpRequestException());

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.getUpgradeInfoError, output: '''

Downloading the Monarch UI for this project's flutter version...

Error while sending request to Monarch API. Please check your internet connection and try again.
''');
      });

      test('output when GET /upgrade_info returns resource not found',
          () async {
        setUpGetUpgradeInfoException01(ResourceNotFoundException());

        fetcher.run();

        await verifyFetcherExit(
            exitCode: MonarchUiFetchExitCodes.getUpgradeInfoError, output: '''

Downloading the Monarch UI for this project's flutter version...

Monarch API returned 404. Resource not found. Please try again or run `monarch run -v`.
''');
      });
    });
  });
}

MonarchBinaries createTempMonarchBinaries() {
  var tempDir = Directory.systemTemp.createTempSync('monarch_ui_fetcher_test_');
  var resolvedDummyExe = p.join(tempDir.path, 'foo.bar');
  return MonarchBinaries(resolvedDummyExe);
}

class TestFetcher extends MonarchUiFetcher {
  late MockVersionApi mockVersionApi;
  MockDownloader? mockDownloader;
  MockUnzipper? mockUnzipper;
  Exception? createMonarchUiDirException;
  Exception? deleteFileException;

  bool zipFileDeleted = false;

  TestFetcher(
      {required StandardOutput stdout_,
      required MonarchBinaries monarchBinaries,
      required String binariesVersionNumber,
      required FlutterSdkId id,
      required String userDeviceId})
      : super(
            stdout_: stdout_,
            monarchBinaries: monarchBinaries,
            binariesVersionNumber: binariesVersionNumber,
            id: id,
            userDeviceId: userDeviceId);

  @override
  VersionApi getVersionApi(String userDeviceId) => mockVersionApi;

  @override
  Downloader getDownloader(String uiBundleUrl) => mockDownloader!;

  @override
  Unzipper getUnzipper(String zipFileName) => mockUnzipper!;

  @override
  Future<void> renameDownloadedUiAsUnknown(UiBundle uiBundle) async {
    // do nothing
  }

  @override
  Future<void> delete(File zipFile) async {
    if (deleteFileException != null) {
      throw deleteFileException!;
    } else {
      zipFileDeleted = true;
    }
  }
}
