import '../utils/standard_output.dart';
import 'performance_overlay_messages.dart' as performance_overlay_messages;

/// Scrapes messages written to the stdout stream of the `runMonarchAppTask` process.
/// Those messages can be from the Preview, the Controller or the Window Manager.
void onMonarchAppStdoutMessage(String message) {
  const errLineMarker = 'flutter: ##err-line##';

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

      if (line
          .contains(performance_overlay_messages.unexpectedVisualDebugFlag)) {
        stdout_default
            .writeln(performance_overlay_messages.monarchPackageUpgrade);
        return;
      }
    } else {
      // no match, nothing to process
    }
  }
}

void _process(String line, String marker, void Function(String message) fn) {
  fn(line.substring(marker.length));
}
