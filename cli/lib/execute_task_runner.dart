import 'dart:io';

import 'package:monarch_cli/src/config/context_info.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';
import 'package:monarch_io_utils/utils.dart';

import 'src/analytics/analytics.dart';
import 'src/analytics/analytics_event.dart';

import 'src/config/context_and_session.dart';
import 'src/config/project_compatibility.dart';
import 'src/config/monarch_binaries.dart';
import 'src/config/project_config.dart';
import 'src/config/validator.dart';
import 'src/config/notifications_reader.dart';
import 'src/crash_reports/crash_reports.dart';
import 'src/monarch_ui/monarch_ui_fetcher.dart';
import 'src/utils/cli_exit_code.dart';
import 'src/task_runner/log_stream_stdout_writer.dart';
import 'src/utils/log_stream_file_writer.dart';
import 'src/task_runner/task_runner.dart';
import 'src/task_runner/task_names.dart';
import 'src/task_runner/task_runner_exit_codes.dart';
import 'src/utils/standard_output.dart';
import 'src/config/environment_mutations.dart';
import 'src/version_api/version_api.dart';
import 'src/version_api/notification.dart';
import 'src/task_runner/grpc.dart';

final _logger = Logger('CommandTaskRunner');

late final LogStreamFileWriter _logStreamFileWriter;
late final LogStreamStdoutWriter _logStreamUserLogger;
late final LogStreamCrashReporter _logStreamCrashReporter;

bool _isVerbose = false;
bool _isCrashDebug = false;

final _crashReporter = CrashReporterImpl(CrashReportBuilder());
final _analytics = AnalyticsImpl(AnalyticsEventBuilder());

EnvironmentMutations? _mutations;

void executeTaskRunner(
    {required bool isVerbose,
    required bool isCrashDebug,
    required bool isDeleteConflictingOutputs,
    required bool noSoundNullSafety,
    required String reloadOption}) async {
  _isVerbose = isVerbose;
  _isCrashDebug = isCrashDebug;

  defaultLogLevel = _isVerbose ? LogLevel.ALL : LogLevel.CONFIG;
  crashReportLoggers.setIsCrashDebugFlag(_isCrashDebug);

  final projectDirectory = Directory.current;
  _setUpLogStreamWriters(projectDirectory);

  _logger.config('Verbose flag is $_isVerbose');
  _logger.config('Default log level is ${defaultLogLevel.name}');

  _logEnvironmentInfo();

  _logger.config('User project directory ${projectDirectory.path}');
  _logger.config(
      'monarch bin directory ${defaultMonarchBinaries.binDirectory.path}');

  final contextInfo = await setUpContextAndSession(
      isVerbose, _crashReporter.builder, _analytics.builder);

  final notificationsReader = NotificationsReader(
      VersionApi(readUserId: contextInfo.userDeviceIdOrUnknown));
  notificationsReader.read(contextInfo);

  final projectConfig =
      TaskRunnerProjectConfig(projectDirectory, contextInfo.internalInfo);
  await projectConfig.validate();

  if (!projectConfig.isValid) {
    _recordAndShowValidationErrors(projectConfig);
    await _exit(TaskRunnerExitCodes.projectConfigNotValid);
    return;
  }

  contextInfo.projectConfig = projectConfig;

  final compatibility = ProjectCompatibility(projectConfig);
  await compatibility.validate();

  if (!compatibility.isValid) {
    _recordAndShowValidationErrors(compatibility);
    await _exit(TaskRunnerExitCodes.compatibilityNotValid);
    return;
  }

  _mutations = EnvironmentMutations(projectConfig);
  await _mutations!.validate();

  if (!_mutations!.isValid) {
    _recordAndShowValidationErrors(_mutations!);
    await _exit(TaskRunnerExitCodes.environmentConfigNotValid);
    return;
  }

  final monarchUiIdDir =
      defaultMonarchBinaries.uiIdDirectory(projectConfig.flutterSdkId);

  if (!await monarchUiIdDir.exists()) {
    var uiFetchExitCode =
        await _fetchMonarchUi(projectConfig, contextInfo, monarchUiIdDir);
    if (uiFetchExitCode.code > 0) {
      await _exit(uiFetchExitCode);
      return;
    }
  } else {
    _logger.info('monarch ui id directory found at ${monarchUiIdDir.path}');
  }

  final notifications = await notificationsReader.notifications;
  _showNotifications(notifications);

  final taskRunner = TaskRunner(
      projectDirectory: projectDirectory,
      config: projectConfig,
      monarchBinaries: defaultMonarchBinaries,
      isVerbose: _isVerbose,
      isDeleteConflictingOutputs: isDeleteConflictingOutputs,
      noSoundNullSafety: noSoundNullSafety,
      reloadOption: _getReloadOption(reloadOption),
      analytics: _analytics,
      controllerGrpcClient: controllerGrpcClientInstance);

  final cliGrpcServer = CliGrpcServer();
  try {
    await cliGrpcServer.startServer(taskRunner, _analytics);
    taskRunner.cliGrpcServerPort = cliGrpcServer.port;
  }
  catch (e, s) {
    await _exit(TaskRunnerExitCodes.cliGrpcServerStartError);
    return;
  }

  _logger.info('Starting Monarch Task Runner');
  stdout_default.writeln('\nStarting Monarch.');
  _analytics.task_runner_start(reloadOption);

  taskRunner.run();
  final _exitCode = await taskRunner.exit;

  _analytics.task_runner_end(_exitCode);
  await _exit(_exitCode);
}

void _recordAndShowValidationErrors(Validator validator) {
  _analytics.task_runner_failed_start(validator.validationErrors);
  stdout_default.writeln(validator.validationErrorsPretty());
}

void _setUpLogStreamWriters(Directory projectDirectory) {
  _logStreamFileWriter = LogStreamFileWriter(
      logEntryStream, '`monarch run` in ${projectDirectory.path}', _isVerbose,
      printTimestamp: true, printLoggerName: true);
  _logStreamFileWriter.setUp();

  final recurrenceConverter = RecurrenceLogEntryConverter(
      shouldTrackRecurrence: (entry) =>
          // only track recurrence for entries greater than warning,
          // otherwise the recurrence map will get huge
          entry.level >= LogLevel.WARNING &&
          entry.loggerName == TaskNames.runMonarchApp);

  final crashStream = logEntryStream
      .map(recurrenceConverter.toRecurrenceLogEntry)
      .asBroadcastStream();

  _logStreamUserLogger = LogStreamStdoutWriter(crashStream);
  _logStreamUserLogger.setUp();

  _logStreamCrashReporter = LogStreamCrashReporter(
      crashStream,
      _isCrashDebug ? LogLevel.WARNING : LogLevel.SEVERE,
      _crashReporter,
      _isCrashDebug,
      shouldIgnore: _isUserCompilerError);
  _logStreamCrashReporter.setUp();
}

ReloadOption _getReloadOption(String reloadOption) {
  switch (reloadOption) {
    case 'hot-reload':
      return ReloadOption.hotReload;
    case 'hot-restart':
      return ReloadOption.hotRestart;
    case 'manual':
      return ReloadOption.manual;

    default:
      throw 'Unexpected reload option $reloadOption';
  }
}

/// The build and attach tasks report mostly user compiler errors.
/// They also tend to report one error in multiple stderr messages
/// which makes it difficult to parse.
/// As of 20200731, the simplest approach is to not report any errors from
/// those tasks.
bool _isUserCompilerError(LogEntry entry) =>
    // When the isCrashDebug flag is set, user compiler errors
    // will generate crash reports.
    !_isCrashDebug &&
    (entry.loggerName == TaskNames.buildPreviewBundle ||
        entry.loggerName == TaskNames.attachToHotRestart);

Future<void> _exit(CliExitCode exitCode) async {
  if (exitCode.isFailure && !_isVerbose) {
    stdout_default
        .writeln('Re-run with the --verbose flag to get more information');
  }

  await pumpEventQueue(times: 100);

  final futures = [
    _analytics.queue.whileProcessingWithTimeout(Duration(milliseconds: 1000)),
    _crashReporter.queue
        .whileProcessingWithTimeout(Duration(milliseconds: 1000)),
    if (_mutations != null) _mutations!.tearDown(),
    _logStreamFileWriter.tearDown(),
    _logStreamUserLogger.tearDown(),
    _logStreamCrashReporter.tearDown(),
  ];

  await Future.wait(futures);

  exit(exitCode.code);
}

void _logEnvironmentInfo() {
  logEnvironmentInformation(_logger, LogLevel.FINE);
  logCurrentProcessInformation(_logger, LogLevel.FINE);
}

Future<CliExitCode> _fetchMonarchUi(ProjectConfig projectConfig,
    ContextInfo contextInfo, Directory monarchUiIdDir) async {
  _logger
      .info('Did not find monarch ui id directory at ${monarchUiIdDir.path}');

  var uiFetcher = MonarchUiFetcher(
      stdout_: stdout_default,
      monarchBinaries: defaultMonarchBinaries,
      binariesVersionNumber: contextInfo.internalInfo.binariesVersion,
      id: projectConfig.flutterSdkId,
      userDeviceId: contextInfo.userDeviceIdOrUnknown);

  _analytics.ui_fetch_start();

  uiFetcher.run();
  var uiFetchExitCode = await uiFetcher.exit;

  _analytics.ui_fetch_end(uiFetchExitCode, uiFetcher.duration);
  return uiFetchExitCode;
}

void _showNotifications(List<Notification> notifications) {
  for (var notification in notifications) {
    stdout_default.writeln();
    stdout_default.writeln('*' * 80);
    stdout_default.writeln(notification.message.trim());
    stdout_default.writeln('*' * 80);
    _analytics.notification_displayed(notification.id);
  }
}
