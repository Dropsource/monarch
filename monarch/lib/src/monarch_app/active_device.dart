import 'active_value.dart';
import 'device_definitions.dart';

class ActiveDevice extends ActiveValue<DeviceDefinition> {
  DeviceDefinition _activeDevice = defaultDeviceDefinition;
  @override
  DeviceDefinition get value => _activeDevice;

  DeviceDefinition getDeviceDefinition(String id) =>
      deviceDefinitions.firstWhere((definition) => definition.id == id,
          orElse: (() => throw ArgumentError(
              'expected to find device definition with id $id')));

  @override
  void setValue(DeviceDefinition newValue) {
    _activeDevice = newValue;
  }

  @override
  String get valueSetMessage => 'active device id set: ${_activeDevice.id}';
}

final activeDevice = ActiveDevice();
