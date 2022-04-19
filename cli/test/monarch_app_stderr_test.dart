import 'package:test/test.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';
import 'package:monarch_cli/src/task_runner/monarch_app_stderr.dart';

void main() {
  group('onRunMonarchAppStdErrMessage', () {
    test('logs multi line message', () async {
      var message = '''
[ERROR:flutter/lib/ui/ui_dart_state.cc(186)] Unhandled Exception: some error on stderr
#0      stderr_ (file:///Users/fertrig/development/scratch/solitude/stories/sample_button_stories.dart:20:45)
#1      _StoryViewState.build (package:monarch/src/monarch_app/story_view.dart:119:41)
#2      StatefulElement.build (package:flutter/src/widgets/framework.dart:4612:27)
#3      ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:4495:15)
#4      StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:4667:11)
#5      Element.rebuild (package:flutter/src/widgets/framework.dart:4189:5)
#6      BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:2694:33)
#7      WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:873:21)
#8      RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:319:5)
#9      SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1144:15)
#10     SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1082:9)
#11     SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:998:5)
#12     _rootRun (dart:async/zone.dart:1354:13)
#13     _CustomZone.run (dart:async/zone.dart:1258:19)
#14     _CustomZone.runGuarded (dart:async/zone.dart:1162:7)
#15     _invoke (dart:ui/hooks.dart:161:10)
#16     PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:253:5)
#17     _drawFrame (dart:ui/hooks.dart:120:31)
''';

      var logEntries = <LogEntry>[];
      logEntryStream.listen((logEntry) => logEntries.add(logEntry));

      var _logger = Logger('monarch-app-stderr-test');
      onRunMonarchAppStdErrMessage(message, _logger);

      await pumpEventQueue();

      expect(logEntries.length, 1);
      expect(logEntries[0].level, LogLevel.SEVERE);
      expect(logEntries[0].message,
          '[ERROR:flutter/lib/ui/ui_dart_state.cc(186)] Unhandled Exception: some error on stderr');
      expect(logEntries[0].errorDetails, isNull);
      expect(logEntries[0].stackTrace, '''
#0      stderr_ (file:///Users/fertrig/development/scratch/solitude/stories/sample_button_stories.dart:20:45)
#1      _StoryViewState.build (package:monarch/src/monarch_app/story_view.dart:119:41)
#2      StatefulElement.build (package:flutter/src/widgets/framework.dart:4612:27)
#3      ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:4495:15)
#4      StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:4667:11)
#5      Element.rebuild (package:flutter/src/widgets/framework.dart:4189:5)
#6      BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:2694:33)
#7      WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:873:21)
#8      RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:319:5)
#9      SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1144:15)
#10     SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1082:9)
#11     SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:998:5)
#12     _rootRun (dart:async/zone.dart:1354:13)
#13     _CustomZone.run (dart:async/zone.dart:1258:19)
#14     _CustomZone.runGuarded (dart:async/zone.dart:1162:7)
#15     _invoke (dart:ui/hooks.dart:161:10)
#16     PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:253:5)
#17     _drawFrame (dart:ui/hooks.dart:120:31)
''');
    });

    test('logs single line message', () async {
      var message = 'some message';

      var logEntries = <LogEntry>[];
      logEntryStream.listen((logEntry) => logEntries.add(logEntry));

      var _logger = Logger('monarch-app-stderr-test');
      onRunMonarchAppStdErrMessage(message, _logger);

      await pumpEventQueue();

      expect(logEntries.length, 1);
      expect(logEntries[0].level, LogLevel.SEVERE);
      expect(logEntries[0].message, 'some message');
      expect(logEntries[0].errorDetails, isNull);
      expect(logEntries[0].stackTrace, isNull);
    });
  });
}
