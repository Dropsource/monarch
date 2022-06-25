import 'dart:async';
import 'dart:developer' as developer;
import 'dart:isolate';
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

  final Map<String, List<String>> _registeredMethodsForService = {};

  /// Connects to the Dart VM service.
  ///
  /// At runtime, the Dart VM Service has at least two isolates:
  /// one for the Monarch Preview and one for the Monarch Controller.
  ///
  /// This method also gets the id of the current isolate, the current
  /// isolate runs the code for the Monarch Preview.
  Future<void> connect() async {
    final info = await developer.Service.getInfo();
    final port = info.serverUri!.port;
    final host = info.serverUri!.host;
    final path = info.serverUri!.path;

    final webSocketUri = 'ws://$host:$port${path}ws';

    _client = await vmServiceConnectUri(webSocketUri, log: VmServiceLog());
    log.fine('Connected to vm service socket $webSocketUri');
    _isolateId = developer.Service.getIsolateID(Isolate.current);
    log.fine('Got isolateId=$_isolateId');

    _onClientDone();

    _client.onServiceEvent.listen(handleServiceEvent);
    await _client.streamListen(vm_service.EventStreams.kService);
    // _client.onEvent(vm_service.EventStreams.kService).listen(handleServiceEvent);

    await _client.streamListen(vm_service.EventStreams.kExtension);
    _client.onExtensionEvent.listen(visual_debug.handleVmServiceExtensionEvent);
  }

  void handleServiceEvent(vm_service.Event e) {
      if (e.kind == vm_service.EventKind.kServiceRegistered) {
        log.shout('Registering service ${e.service!} with method ${e.method!}');
        final serviceName = e.service!;
        _registeredMethodsForService
            .putIfAbsent(serviceName, () => [])
            .add(e.method!);
      }

      if (e.kind == vm_service.EventKind.kServiceUnregistered) {
        final serviceName = e.service!;
        _registeredMethodsForService.remove(serviceName);
      }
    }

  void _onClientDone() async {
    await _client.onDone;
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

  Future<void> hotReload() async {
    try {
      // await _reloadSources(force: false);
      log.shout('reloadSources...');
      // await _client.callMethod('reloadSources', isolateId: _isolateId);
      await callService('reloadSources');
    } catch (e, s) {
      log.severe('Error hot reloading', e, s);
    }
  }

  Future<void> hotRestart() async {
    try {
      // await _reloadSources(force: true);
      log.shout('hotRestart...');
      // await _client.callMethod('hotRestart', isolateId: _isolateId);
      await callService('hotRestart');
    } catch (e, s) {
      log.severe('Error hot restarting', e, s);
    }
  }

  /// Call a service that is registered by exactly one client.
  Future<vm_service.Response> callService(
    String name, {
    Map<String, dynamic>? args,
  }) async {
    final registered = _registeredMethodsForService[name] ?? const [];
    if (registered.isEmpty) {
      throw Exception('There are no registered methods for service "$name"');
    }
    return _client.callMethod(
      registered.first,
      isolateId: _isolateId,
      args: args,
    );
  }

  Future<vm_service.ReloadReport> _reloadSources({required bool force}) =>
      _client.reloadSources(_isolateId!, force: force);
}

class VmServiceLog extends vm_service.Log with Log {
  @override
  void warning(String message) => log.warning(message);

  @override
  void severe(String message) => log.severe(message);
}

final vmServiceClient = VmServiceClient();
