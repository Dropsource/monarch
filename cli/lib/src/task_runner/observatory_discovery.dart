import 'dart:async';
import 'package:monarch_utils/log.dart';

/// Scrapes logs (i.e. stdout) stream and find the observatory uri.
/// Adapted from:
/// https://github.com/flutter/flutter/blob/6067571fabca7e104f15d0bd74de50568cb4597a/packages/flutter_tools/lib/src/protocol_discovery.dart
class ObservatoryDiscovery with Log {

  void listen(Stream<String> logStream) {
    _deviceLogSubscription = logStream.listen(
      _handleLine,
      onDone: _stopScrapingLogs,
    );
  }

  static const serviceName = 'Observatory';

  late final StreamSubscription<String> _deviceLogSubscription;

  Uri? _observatoryUri;
  Uri? get observatoryUri {
    return _observatoryUri;
  }

  Future<void> cancel() => _stopScrapingLogs();

  Future<void> _stopScrapingLogs() async {
    await _deviceLogSubscription.cancel();
  }

  Match? _getPatternMatch(String line) {
    final r = RegExp(RegExp.escape(serviceName) +
        r' listening on ((http|//)[a-zA-Z0-9:/=_\-\.\[\]]+)');
    return r.firstMatch(line);
  }

  Uri? _getObservatoryUri(String line) {
    final match = _getPatternMatch(line);
    if (match != null) {
      return Uri.parse(match[1]!);
    }
    return null;
  }

  void _handleLine(String line) {
    Uri? uri;
    try {
      uri = _getObservatoryUri(line);
    } on FormatException catch (error, stackTrace) {
      log.warning('FormatException while trying to get observatory url', error,
          stackTrace);
    }
    if (uri == null) {
      return;
    }
    _observatoryUri = uri;
  }
}
