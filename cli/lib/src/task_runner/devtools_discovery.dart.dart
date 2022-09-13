import 'dart:async';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:monarch_utils/log.dart';

enum DiscoveryStatus { initial, listening, found, notFound }

/// Scrapes a stream of string lines and finds the devtools uri.
class DevtoolsDiscovery with Log {

  DiscoveryStatus _status = DiscoveryStatus.initial;
  DiscoveryStatus get status => _status;

  void listen(Stream<String> logStream) {
    _status = DiscoveryStatus.listening;
    _subscription = logStream.listen(
      _handleLine,
      onDone: _stopScrapingLogs,
    );
  }

  String get matchPrefix => valueForPlatform(
      macos: 'The Flutter DevTools debugger and profiler on macOS',
      windows: 'The Flutter DevTools debugger and profiler on Windows');

  late final StreamSubscription<String> _subscription;

  Uri? _devtoolsUri;
  Uri? get devtoolsUri {
    return _devtoolsUri;
  }

  Future<void> cancel() => _stopScrapingLogs();

  Future<void> _stopScrapingLogs() async {
    if (status == DiscoveryStatus.listening) {
      _status = DiscoveryStatus.notFound;
    }
    await _subscription.cancel();
  }

  Match? _getPatternMatch(String line) {
    final r = RegExp(RegExp.escape(matchPrefix) +
        r' is available at: ((http|//)[a-zA-Z0-9:/=_\-\.\[\]\?\%]+)');
    return r.firstMatch(line);
  }

  Uri? _getDevtoolsUri(String line) {
    final match = _getPatternMatch(line);
    if (match != null) {
      return Uri.parse(match[1]!);
    }
    return null;
  }

  void _handleLine(String line) {
    Uri? uri;
    try {
      uri = _getDevtoolsUri(line);
    } on FormatException catch (error, stackTrace) {
      log.warning('FormatException while trying to get devtools url', error,
          stackTrace);
    }
    if (uri == null) {
      return;
    }
    _devtoolsUri = uri;
    _status = DiscoveryStatus.found;
    log.fine('Discovered DevTools URI: $devtoolsUri');
    _stopScrapingLogs();
  }
}
