import 'dart:async';
import 'dart:developer' as developer;
import 'package:vm_service/vm_service.dart' as vm_service;
import 'package:vm_service/vm_service_io.dart';
import 'package:monarch_utils/log.dart';
import 'visual_debug_flags.dart' as visual_debug;

const maxReconnectTries = 5;
int reconnectCount = 0;

class VmServiceClient with Log {
  VmServiceClient();

  late vm_service.VmService _client;
  late String? _isolateId;

  late StreamSubscription _onExtensionEventSubscription;

  Future<void> connect() async {
    final info = await developer.Service.getInfo();
    final port = info.serverUri!.port;
    final host = info.serverUri!.host;
    final path = info.serverUri!.path;

    final webSocketUri = 'ws://$host:$port${path}ws';

    _client = await vmServiceConnectUri(webSocketUri, log: VmServiceLog());
    log.fine('Connected to vm service socket $webSocketUri');
    final vm = await _client.getVM();
    _isolateId = vm.isolates!.first.id;
    log.fine('Got isolateId=$_isolateId');

    await _client.streamListen(vm_service.EventStreams.kExtension);
    _onExtensionEventSubscription = _client.onExtensionEvent
        .listen(visual_debug.handleVmServiceExtensionEvent);

    _onClientDone();
  }

  void _onClientDone() async {
    await _client.onDone;

    await _client.streamCancel(vm_service.EventStreams.kExtension);
    await _onExtensionEventSubscription.cancel();

    if (reconnectCount < maxReconnectTries) {
      log.warning(
          'Connection to VmService terminated unexpectedly. Reconnecting. Reconnection try $reconnectCount.');
      reconnectCount++;
      await connect();
    } else {
      log.warning(
          'Connection to VmService terminated unexpectedly. Max reconnection tries reached.');
    }
  }

  Future<void> callServiceExtension(
      String method, Map<String, dynamic> args) async {
    try {
      await _callServiceExtensionMethod(method, args);
    } catch (e, s) {
      log.severe('Error calling vm service extension method $method', e, s);
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
      _client.callServiceExtension(method, isolateId: _isolateId, args: args);
}

class VmServiceLog extends vm_service.Log with Log {
  @override
  void warning(String message) => log.warning(message);

  @override
  void severe(String message) => log.severe(message);
}

final vmServiceClient = VmServiceClient();
