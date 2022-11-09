import 'dart:io';
import 'dart:async';

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'execute_common.dart';

import 'src/config/context_and_session.dart';
import 'src/config/monarch_binaries.dart';
import 'src/crash_reports/crash_reports.dart';
import 'src/init/newsletter.dart';
import 'src/upgrade/upgrader.dart';
import 'src/version_api/version_api.dart';
import 'package:path/path.dart' as p;

void executeWindowsUpgradeFirstPass(bool isVerbose, bool isCrashDebug) async {
  var tempDir = Directory.systemTemp.createTempSync('monarch_upgrade_exe_');
  var monarchExeFile = File(defaultMonarchBinaries.monarchExecutablePath);
  var monarchTempExePath =
      p.join(tempDir.path, p.basename(monarchExeFile.path));
  await monarchExeFile.copy(monarchTempExePath);

  var upgradeCmd = '$monarchTempExePath upgrade';
  if (isVerbose) upgradeCmd += ' --verbose';
  if (isCrashDebug) upgradeCmd += ' --crash-debug';
  upgradeCmd += ' --windows-second-pass --monarch-exe ${monarchExeFile.path}';

  var upgradeBatFile = File(p.join(tempDir.path, 'monarch_upgrade.bat'));
  await upgradeBatFile.writeAsString('''
@echo off

$upgradeCmd

echo.
pause
exit

      ''');

  unawaited(Process.start('start', ['', upgradeBatFile.path],
      runInShell: true, mode: ProcessStartMode.detached));
}

void executeUpgrade(
    bool isVerbose, bool isCrashDebug, String? monarchExecutablePath) async {
  var executor = _UpgradeExecutor();
  executor.executeUpgrade(isVerbose, isCrashDebug, monarchExecutablePath);
}

class _UpgradeExecutor with CommonExecutor {
  void executeUpgrade(bool _isVerbose, bool _isCrashDebug,
      String? monarchExecutablePath) async {
    isVerbose = _isVerbose;
    isCrashDebug = _isCrashDebug;

    defaultLogLevel = LogLevel.ALL;
    crashReportLoggers.setIsCrashDebugFlag(isCrashDebug);

    setUpLogStreamWriters('`monarch upgrade`');

    final contextInfo = await setUpContextAndSession(
        isVerbose, crashReporter.builder, analytics.builder);

    final newsletter = Newsletter(analytics);
    await newsletter.askToJoin(checkIfEmailAlreadyCaptured: true);

    final upgrader = Upgrader(
        monarchExecutablePath == null
            ? defaultMonarchBinaries
            : MonarchBinaries(monarchExecutablePath),
        VersionApi(readUserId: contextInfo.userDeviceIdOrUnknown),
        Platform.operatingSystem,
        contextInfo);

    analytics.upgrade_start();

    upgrader.run();
    final exitCode = await upgrader.exit;

    analytics.upgrade_end(
        exitCode, upgrader.latestVersion?.versionNumber, upgrader.duration);

    await exit_(exitCode);
  }
}
