import 'active_value.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

class ActiveDevice extends ActiveValue<DeviceDefinition> {
  DeviceDefinition _activeDevice = defaultDeviceDefinition;
  @override
  DeviceDefinition get value => _activeDevice;

  @override
  void setValue(DeviceDefinition newValue) {
    _activeDevice = newValue;
  }

  @override
  String get valueSetMessage => 'active device id set: ${_activeDevice.id}';
}

final activeDevice = ActiveDevice();
