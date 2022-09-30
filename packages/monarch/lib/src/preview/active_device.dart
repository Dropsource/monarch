import 'active_value.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

class ActiveDevice extends ActiveValue<DeviceDefinition> {
  DeviceDefinition _activeDevice = defaultDeviceDefinition;
  @override
  DeviceDefinition get value => _activeDevice;

  DeviceDefinition getDeviceDefinition(String id) =>
      // @TODO: the preview_server will pass the list of device defintions via method channel
      //        the preview_server will have the list of devices from now on, which will let
      //        us ship new devices without having to modify the monarch package
      // Actually, don't pass the id anymore, just pass the whole DeviceDefinition object,
      // the preview_server will pass the device object via method channel, that way the 
      // preview doesn't need the list of devices, it just needs the map functions to 
      // de-serialize the map into the selected device
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
