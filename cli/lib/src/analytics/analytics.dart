// ignore_for_file: non_constant_identifier_names
import 'package:monarch_utils/log.dart';

import 'analytics_api.dart';
import 'analytics_event_queue.dart';
import 'analytics_event.dart';

import '../utils/cli_exit_code.dart';
import '../elasticsearch/elasticsearch_indexes.dart' as indexes;

abstract class Analytics {
  void ui_fetch_start();
  void ui_fetch_end(CliExitCode exitCode, Duration duration);

  void notification_displayed(String notificationId);

  void task_runner_start(String reloadOption);
  void task_runner_failed_start(List<String> errors);
  void task_runner_end(CliExitCode exitCode);

  void task_done(String taskName, Duration duration);
  void task_ready(String taskName, Duration duration);

  void user_selection(Map<String, dynamic> properties);

  void upgrade_start();
  void upgrade_end(
      CliExitCode exitCode, String latestVersionNumber, Duration duration);

  void init_start();
  void init_end(CliExitCode exitCode, Duration duration);
  void init_failed_start(List<String> errors);

  Future<void> newsletter_joined(String email);
  void newsletter_skipped();
}

class AnalyticsImpl with Log implements Analytics {
  final AnalyticsEventBuilder builder;
  AnalyticsEventsQueue _queue = AnalyticsEventsQueue(AnalyticsApi());
  AnalyticsEventsQueue get queue => _queue;

  AnalyticsImpl(this.builder) {
    log.level = LogLevel.OFF; // off until we implement analytics logging
  }

  void record(AnalyticsEvent Function() fn) {
    try {
      final event = fn();
      _queue.enqueue(event);
    } catch (e, s) {
      // users see severe logs, we don't want to surface analytics errors
      log.warning('error while recording analytics event', e, s);

      // create a new queue just in case its internal state is unexpected
      _queue = AnalyticsEventsQueue(AnalyticsApi());
    }
  }

  Future<void> recordFuture(AnalyticsEvent Function() fn) async {
    try {
      var event = fn();
      var api = AnalyticsApi();
      await api.recordSingleEvent(event.collectionName, event.properties);
    } catch (e, s) {
      log.warning('error while recording analytics event (future)', e, s);
    }
  }

  @override
  void ui_fetch_start() {
    record(() => builder.buildCommonEvent(indexes.ui_fetch_start, {}));
  }

  @override
  void ui_fetch_end(CliExitCode exitCode, Duration duration) {
    record(() => builder.buildCommonEvent(indexes.ui_fetch_end, {
          'exit_code': builder.getCliExitCodeProperties(exitCode),
          'duration': builder.getDurationProperties(duration)
        }));
  }

  @override
  void notification_displayed(String notificationId) {
    record(() => builder.buildCommonEvent(
        indexes.notification_displayed, {'notification_id': notificationId}));
  }

  @override
  void task_runner_start(String reloadOption) {
    record(() => builder.buildCommonEvent(indexes.task_runner_start, {
          'task_runner_process_memory': builder.getProcessMemoryProperties(),
          'reload_option': reloadOption
        }));
  }

  @override
  void task_runner_failed_start(List<String> errors) {
    record(() => builder.buildCommonEvent(indexes.task_runner_failed_start,
        {'first_error': errors[0], 'errors': errors}));
  }

  @override
  void task_runner_end(CliExitCode exitCode) {
    record(() => builder.buildCommonEvent(indexes.task_runner_end, {
          'exit_code': builder.getCliExitCodeProperties(exitCode),
          'task_runner_process_memory': builder.getProcessMemoryProperties()
        }));
  }

  @override
  void task_done(String taskName, Duration duration) {
    record(() => builder.buildCommonEvent(indexes.task_done, {
          'task_name': taskName,
          'duration': builder.getDurationProperties(duration)
        }));
  }

  @override
  void task_ready(String taskName, Duration duration) {
    record(() => builder.buildCommonEvent(indexes.task_ready, {
          'task_name': taskName,
          'duration': builder.getDurationProperties(duration)
        }));
  }

  @override
  void user_selection(Map<String, dynamic> properties) {
    record(() {
      properties['task_runner_process_memory'] =
          builder.getProcessMemoryProperties();
      return builder.buildCommonEvent(indexes.user_selection, properties);
    });
  }

  @override
  void upgrade_start() {
    record(() => builder.buildCommonEvent(indexes.upgrade_start, {}));
  }

  @override
  void upgrade_end(
      CliExitCode exitCode, String? upgradeVersionNumber, Duration duration) {
    record(() => builder.buildCommonEvent(indexes.upgrade_end, {
          'exit_code': builder.getCliExitCodeProperties(exitCode),
          'upgrade': {
            'version_number': upgradeVersionNumber,
            'duration': builder.getDurationProperties(duration)
          }
        }));
  }

  @override
  void init_start() {
    record(() => builder.buildCommonEvent(indexes.init_start, {}));
  }

  @override
  void init_end(CliExitCode exitCode, Duration duration) {
    record(() => builder.buildCommonEvent(indexes.init_end, {
          'exit_code': builder.getCliExitCodeProperties(exitCode),
          'init': {'duration': builder.getDurationProperties(duration)}
        }));
  }

  @override
  void init_failed_start(List<String> errors) {
    record(() => builder.buildCommonEvent(indexes.init_failed_start,
        {'first_error': errors[0], 'errors': errors}));
  }

  @override
  Future<void> newsletter_joined(String email) {
    return recordFuture(() =>
        builder.buildCommonEvent(indexes.newsletter_joined, {'email': email}));
  }

  @override
  void newsletter_skipped() {
    record(() => builder.buildCommonEvent(indexes.newsletter_skipped, {}));
  }
}
