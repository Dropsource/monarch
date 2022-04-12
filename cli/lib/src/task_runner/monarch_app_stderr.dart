import 'dart:io';

import 'package:monarch_utils/log.dart';

/// This funcion handles scenarios where the monarch ui app or the generated
/// flutter app write to stderr.
///
/// Keep in mind that not all errors are written to stderr. For example,
/// compile errors and render overflow errors are written to stdout. Errors
/// in stdout are handled using markers, i.e. `###error-in-story###` marker.
///
/// Messages written to stderr have usually come from plugins, like the
/// Google Font plugin which used to fail like this:
/// ```
/// Unhandled Exception: MissingPluginException(No implementation found for method getApplicationSupportDirectory on channel plugins.flutter.io/path_provider)
/// ...
/// (stack trace)
/// ...
/// ```
///
/// This function parses multi-line stderr messages so they are logged adequately.
///
/// This function is also used to ignore messages written to stderr
/// that we don't want to surface as errors to the user.
///
/// Around 2021-03-15, the mac app started writing a message like the following
/// to stderr:
/// ```
/// 2021-05-13 19:14:16.165 monarch[70530:10028639] Cannot find executable for CFBundle 0x7fc54466d140 </path/to/project/.monarch> (not loaded)
/// ```
/// This issue was also reported here: https://github.com/Dropsource/monarch/issues/15
///
/// This "CFBundle" error message doesn't manifest any unexpected behavior. It is
/// also pretty hard to fix. The error seems to be common and the fixes
/// are not straight forward. We are just ignoring for now.
void onRunMonarchAppStdErrMessage(String message, Logger _logger) {
  final newLineIndex = message.indexOf('\n');

  if (newLineIndex > -1 && newLineIndex < message.length - 1) {
    final parsedMessage = message.substring(0, newLineIndex).trimLeft();
    final stackTrace = message.substring(newLineIndex).trimLeft();
    _logger.severe(parsedMessage, null, StackTrace.fromString(stackTrace));
    return;
  }

  if (Platform.isMacOS) {
    var cannotFindBundle = RegExp(
        r'Cannot find executable for CFBundle .* <.*\.monarch> \(not loaded\)');

    if (cannotFindBundle.hasMatch(message)) {
      _logger.info('**ignored-severe** $message');
      return;
    }
  }

  _logger.severe(message);
}
