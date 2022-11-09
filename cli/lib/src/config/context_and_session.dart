import 'context_info.dart';
import 'internal_info.dart';
import 'monarch_binaries.dart';
import 'session_manager.dart';

mixin ContextAndSession {
  ContextInfo? contextInfo;
  SessionManager? sessionManager;
}

Future<ContextInfo> setUpContextAndSession(
    bool isVerbose,
    ContextAndSession crashReportBuilder,
    ContextAndSession analyticsEventBuilder) async {
  var internal = await readInternalFiles(defaultMonarchBinaries);

  final contextInfo = ContextInfo(isVerbose, internal);

  await contextInfo.readContext();

  final sessionManager = SessionManager();

  crashReportBuilder
    ..contextInfo = contextInfo
    ..sessionManager = sessionManager;

  analyticsEventBuilder
    ..contextInfo = contextInfo
    ..sessionManager = sessionManager;

  return contextInfo;
}
