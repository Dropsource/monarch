import 'package:flutter/foundation.dart';

import 'logical_resolution.dart';

const String _ios = 'ios';
const String _android = 'android';

TargetPlatform? targetPlatformFromString(String platform) {
  return platform == _ios
      ? TargetPlatform.iOS
      : platform == _android
          ? TargetPlatform.android
          : null;
}

class DeviceDefinition {
  const DeviceDefinition({
    required this.id,
    required this.name,
    required this.logicalResolution,
    required this.devicePixelRatio,
    required this.targetPlatform,
  });
  final String id, name;
  final TargetPlatform? targetPlatform;
  final LogicalResolution logicalResolution;
  final double devicePixelRatio;

  static DeviceDefinition fromStandardMap(Map<String, dynamic> args) {
    return DeviceDefinition(
        id: args['id'],
        name: args['name'],
        logicalResolution: LogicalResolution.fromStandardMap(
            Map<String, dynamic>.from(args['logicalResolution'])),
        devicePixelRatio: args['devicePixelRatio'],
        targetPlatform: targetPlatformFromString(args['targetPlatform']));
  }
}

List<DeviceDefinition> getDeviceDefinitions(Map<String, dynamic> args) {
  var defsArg = args['definitions'] as List<dynamic>;
  return defsArg
      .map(
          (e) => DeviceDefinition.fromStandardMap(Map<String, dynamic>.from(e)))
      .toList();
}

const iPhone13DeviceDefinition = DeviceDefinition(
  id: 'ios-iphone-13',
  name: 'iPhone 13',
  logicalResolution: LogicalResolution(
    height: 844,
    width: 390,
  ),
  devicePixelRatio: 3.0,
  targetPlatform: TargetPlatform.iOS,
);

const defaultDeviceDefinition = iPhone13DeviceDefinition;
