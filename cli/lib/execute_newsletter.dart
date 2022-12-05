import 'package:monarch_cli/src/utils/cli_exit_code.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

import 'execute_common.dart';
import 'src/config/context_and_session.dart';
import 'src/crash_reports/crash_reports.dart';
import 'src/init/newsletter.dart';

void executeJoinNewsletter(bool isVerbose, bool isCrashDebug) async {
  var executor = _NewsletterExecutor();
  executor.execute(isVerbose, isCrashDebug);
}

class _NewsletterExecutor with CommonExecutor {
  void execute(bool isVerbose_, bool isCrashDebug_) async {
    isVerbose = isVerbose_;
    isCrashDebug = isCrashDebug_;

    defaultLogLevel = LogLevel.ALL;
    crashReportLoggers.setIsCrashDebugFlag(isCrashDebug);

    setUpLogStreamWriters('`monarch newsletter`');

    await setUpContextAndSession(
        isVerbose, crashReporter.builder, analytics.builder);

    final newsletter = Newsletter(analytics);
    await newsletter.askToJoin(checkIfEmailAlreadyCaptured: false);

    await exit_(CliExitCode(0, 'Newsletter command success', false));
  }
}
