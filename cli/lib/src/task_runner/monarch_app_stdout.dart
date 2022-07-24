import 'package:monarch_io_utils/utils.dart';

import '../analytics/analytics.dart';
import '../utils/standard_output.dart';

/// Scrapes messages written to the stdout stream of the `runMonarchAppTask` process.
/// Those messages can be from the preview app or the monarch desktop app.
///
/// @GOTCHA: The scraping is not trivial and it has gotten complex over time. This
/// approach won't scale well. If you find yourself adding more markers to do 
/// different things, then consider creating a better communication channel
/// between the `runMonarchAppTask` process and this CLI process. Perhaps use
/// gRPC.
///
/// ### gRPC Approach
/// In a gRPC approach, the CLI would host the gRPC server listening on some port.
/// Then, either the flutter app or the desktop app, instead of writing to stdout,
/// would send messages to the gRPC server.
///
/// If the flutter app sends the messages, then the monarch package will need the
/// gRPC package dependencies and code generation which may bloat the dependencies
/// on the user's project. The communication code will be reusable though. The desktop
/// app would send any messages to the flutter app via the existing method channels,
/// then the flutter app would forward those messages to the CLI gRPC server.
///
/// If the desktop app sends the messages, then the monarch package will remain
/// free of gRPC code. We would need gRPC client code on both mac and windows. The
/// flutter app would send any messages to the desktop app, which will then forward
/// to the gRPC server.
class MonarchAppStdoutListener {
  final Analytics analytics;

  MonarchAppStdoutListener(this.analytics);

  void listen(String message) {
    const userLineMarker = 'flutter: ##usr-line##';
    const errLineMarker = 'flutter: ##err-line##';

    var platformPrefix =
        valueForPlatform(macos: 'mac_app', windows: 'windows_app');
    var userSelectionMarker = '$platformPrefix: ###user-selection:start###';

    // Every line we want to process should be prefixed with a marker:
    // - Messages from flutter app are printed one line at a time,
    //   they should arrive one line at a time as well.
    // - Messages from mac_app may arrive together with other messages in
    //   multiple lines, this code also works for windows_app.
    // - Every message from a desktop app is printed in one line, even though
    //   it may arrive combined with other messages in multiple lines.

    // Splitting the message in case we get multiple lines in one message.
    // Every line should have a prefix.
    var lines = message.split('\n');

    for (var line in lines) {
      if (line.startsWith(errLineMarker)) {
        _process(line, errLineMarker, stdout_default.writeln);
      } else if (line.startsWith(userLineMarker)) {
        _process(line, userLineMarker, stdout_default.writeln);
      } else if (line.startsWith(userSelectionMarker)) {
        _process(line, userSelectionMarker, _recordUserSelection);
      } else {
        // no match, nothing to process
      }
    }
  }

  void _process(String line, String marker, void Function(String message) fn) {
    fn(line.substring(marker.length));
  }

  void _recordUserSelection(String innerMessage) {
    final properties =
        _getAnalyticsProperties(innerMessage, '###user-selection:end###');
    analytics.user_selection(properties);
  }

  Map<String, dynamic> _getAnalyticsProperties(
      String innerMessage, String endMarker) {
    final endIndex = innerMessage.indexOf(endMarker);
    if (endIndex > -1) {
      innerMessage = innerMessage.substring(0, endIndex);
      return _convertMessageToAnalyticsProperties(innerMessage);
    } else {
      return <String, dynamic>{};
    }
  }

  Map<String, dynamic> _convertMessageToAnalyticsProperties(String message) {
    // kind=story_selected locale_count=0 user_theme_count=0 story_count=3 selected_device=ios-iphone-12 selected_text_scale_factor=1.0 selected_story_scale=1.0 selected_dock_side=right slow_animations_enabled=false show_guidelines_enabled=false show_baselines_enabled=false highlight_repaints_enabled=false highlight_oversized_images_enabled=false
    try {
      message = message.trim();
      final pairs = message.split(RegExp(r'\s+'));
      final properties = <String, dynamic>{};
      for (var pair in pairs) {
        final parts = pair.split('=');
        final key = parts[0];
        final value = parts[1];

        if (key == 'locale_count' ||
            key == 'user_theme_count' ||
            key == 'story_count') {
          properties[key] = int.parse(value);
        } else if (key == 'selected_device' ||
            key == 'kind' ||
            key == 'selected_dock_side') {
          properties[key] = value;
        } else if (key.endsWith('_enabled')) {
          properties[key] = value == 'true';
        } else if (key == 'selected_text_scale_factor' ||
            key == 'selected_story_scale') {
          properties[key] = double.parse(value);
        }
      }
      return properties;
    } catch (_) {
      // log when we have analytics log
      return <String, dynamic>{};
    }
  }
}
