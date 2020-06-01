import 'dart:async';

import 'package:dropsource_storybook_utils/log.dart';

import 'device_definitions.dart';

class ActiveDevice with Log {
  DeviceDefinition _activeDevice;
  DeviceDefinition get activeDevice => _activeDevice;

  final _activeDeviceStreamController = StreamController<void>.broadcast();
  Stream<void> get activeDeviceStream => _activeDeviceStreamController.stream;

  void setActiveDevice(String id) {
    _activeDevice = deviceDefinitions.firstWhere(
        (definition) => definition.id == id,
        orElse: () => throw ArgumentError(
            'expected to find device definition with id $id'));
    
    _activeDeviceStreamController.add(null);
    log.fine('active device id set: ${_activeDevice.id}');
  }

  void resetActiveDevice() {
    _activeDevice = defaultDeviceDefinition;
  }

  void close() {
    _activeDeviceStreamController.close();
  }
}

final activeDevice = ActiveDevice();
