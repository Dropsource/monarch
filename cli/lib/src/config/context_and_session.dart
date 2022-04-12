import 'context_info.dart';
import 'session_manager.dart';

mixin ContextAndSession {
  ContextInfo? contextInfo;
  SessionManager? sessionManager;
}

Future<ContextInfo> setUpContextAndSession(
    bool isVerbose,
    ContextAndSession crashReportBuilder,
    ContextAndSession analyticsEventBuilder) async {
  final contextInfo = ContextInfo(isVerbose);

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
