import 'dart:io';

import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'execute_common.dart';

import 'src/config/context_and_session.dart';
import 'src/config/monarch_binaries.dart';
import 'src/config/project_config.dart';
import 'src/crash_reports/crash_reports.dart';
import 'src/init/initializer.dart';
import 'src/init/init_exit_codes.dart';
import 'src/init/newsletter.dart';
import 'src/utils/standard_output.dart';

final _logger = Logger('CommandInit');

void executeInit(bool isVerbose, bool isCrashDebug) async {
  var executor = _InitExecutor();
  executor.executeInit(isVerbose, isCrashDebug);
}

class _InitExecutor with CommonExecutor {
  void executeInit(bool _isVerbose, bool _isCrashDebug) async {
    isVerbose = _isVerbose;
    isCrashDebug = _isCrashDebug;

    defaultLogLevel = LogLevel.ALL;
    crashReportLoggers.setIsCrashDebugFlag(isCrashDebug);

    final projectDirectory = Directory.current;
    setUpLogStreamWriters('`monarch init` in ${projectDirectory.path}');

    _logger.config('User project directory ${projectDirectory.path}');
    _logger.config(
        'monarch bin directory ${defaultMonarchBinaries.binDirectory.path}');

    final contextInfo = await setUpContextAndSession(
        isVerbose, crashReporter.builder, analytics.builder);

    final projectConfig = ProjectConfig(projectDirectory);
    await projectConfig.validate();

    if (projectConfig.isValid) {
      contextInfo.projectConfig = projectConfig;

      final newsletter = Newsletter(analytics);
      await newsletter.askToJoin(checkIfEmailAlreadyCaptured: true);

      final initializer = Initializer(projectConfig);

      analytics.init_start();

      initializer.run();
      final exitCode = await initializer.exit;

      analytics.init_end(exitCode, initializer.duration);

      await exit_(exitCode);
    } else {
      analytics.init_failed_start(projectConfig.validationErrors);
      stdout_default.writeln(projectConfig.validationErrorsPretty());
      await exit_(InitExitCodes.projectConfigNotValid);
    }
  }
}
