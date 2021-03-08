import 'dart:developer' as developer;
import 'package:vm_service/vm_service.dart' as vm_service;
import 'package:vm_service/vm_service_io.dart';
import 'package:monarch_utils/log.dart';

const maxReconnectTries = 5;
int reconnectCount = 0;

class VmServiceClient with Log {
  VmServiceClient();

  vm_service.VmService _client;
  String _isolateId;

  Future<void> connect() async {
    final info = await developer.Service.getInfo();
    final port = info.serverUri.port;
    final host = info.serverUri.host;
    final path = info.serverUri.path;

    final webSocketUri = 'ws://$host:$port${path}ws';

    _client = await vmServiceConnectUri(webSocketUri, log: VmServiceLog());
    log.fine('Connected to vm service socket $webSocketUri');
    final vm = await _client.getVM();
    _isolateId = vm.isolates.first.id;
    log.fine('Got isolateId=$_isolateId');

    _onClientDone();
  }

  void _onClientDone() {
    _client.onDone.then((_) async {
      if (reconnectCount < maxReconnectTries) {
        log.warning('VmService terminated unexpectedly. Reconnecting. Reconnection try $reconnectCount.');
        reconnectCount++;
        await connect();
      }
      else {
        log.warning('VmService terminated unexpectedly. Max reconnection tries reached.');
      }
    });
  }

  Future<void> toogleDebugPaint(bool isEnabled) async {
    if (_client == null) {
      throw StateError('method connect must be called first');
    }
    ArgumentError.checkNotNull(isEnabled, 'isEnabled');

    try {
      await _callServiceExtensionMethod(
          'ext.flutter.debugPaint', {'enabled': isEnabled});
    } catch (e, s) {
      log.severe(
          'Error while calling debug paint method, isEnabled=$isEnabled', e, s);
    }
  }

  /// Calls `callServiceExtension` on the VmService client.
  ///
  /// The response from `VmService.callServiceExtension` looks like:
  /// type: "_extensionType"
  /// json:
  /// {
  ///     "enabled": "true",
  ///     "type": "_extensionType",
  ///     "method": "ext.flutter.debugPaint"
  /// }
  Future<vm_service.Response> _callServiceExtensionMethod(
          String method, Map<String, dynamic> args) =>
      _client.callMethod(method,
          isolateId: _isolateId, args: args);
}

class VmServiceLog extends vm_service.Log with Log {
  @override
  void warning(String message) => log.warning(message);

  @override
  void severe(String message) => log.severe(message);
}

final vmServiceClient = VmServiceClient();
