import 'package:flutter/foundation.dart';

import 'channel_methods.dart';
import 'logical_resolution.dart';

const String _ios = 'ios';
const String _android = 'android';

String targetPlatformToString(TargetPlatform platform) {
  return platform == TargetPlatform.iOS
      ? _ios
      : platform == TargetPlatform.android
          ? _android
          : null;
}

TargetPlatform targetPlatformFromString(String platform) {
  return platform == _ios
      ? TargetPlatform.iOS
      : platform == _android
          ? TargetPlatform.android
          : null;
}

class DeviceDefinition implements OutboundChannelArgument {
  const DeviceDefinition({
    this.id,
    this.name,
    this.logicalResolution,
    this.devicePixelRatio,
    this.targetPlatform,
  });
  final String id, name;
  final TargetPlatform targetPlatform;
  final LogicalResolution logicalResolution;
  final double devicePixelRatio;

  @override
  Map<String, dynamic> toStandardMap() {
    return {
      'id': id,
      'name': name,
      'logicalResolution': logicalResolution.toStandardMap(),
      'devicePixelRatio': devicePixelRatio,
      'targetPlatform': targetPlatformToString(targetPlatform),
    };
  }
}

class DeviceDefinitions implements OutboundChannelArgument {
  @override
  Map<String, dynamic> toStandardMap() {
    return {
      'definitions': deviceDefinitions.map((d) => d.toStandardMap()).toList(),
    };
  }
}

const iPhoneXDeviceDefinition = DeviceDefinition(
  id: 'ios-iphone-x',
  name: 'iPhone X',
  logicalResolution: LogicalResolution(
    height: 812,
    width: 375,
  ),
  devicePixelRatio: 3.0,
  targetPlatform: TargetPlatform.iOS,
);

final defaultDeviceDefinition = iPhoneXDeviceDefinition;

/// iOS logical resolutions can be found here: http://iosres.com/
const deviceDefinitions = [
  iPhoneXDeviceDefinition,
  DeviceDefinition(
    id: 'ios-iphone-8-plus',
    name: 'iPhone 8 Plus',
    logicalResolution: LogicalResolution(
      height: 736,
      width: 414,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-8',
    name: 'iPhone 8',
    logicalResolution: LogicalResolution(
      height: 667,
      width: 375,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-5',
    name: 'iPhone 5',
    logicalResolution: LogicalResolution(
      height: 568,
      width: 320,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-4',
    name: 'iPhone 4',
    logicalResolution: LogicalResolution(
      height: 480,
      width: 320,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-pro',
    name: 'iPad Pro',
    logicalResolution: LogicalResolution(
      height: 1366,
      width: 1024,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-mini',
    name: 'iPad Mini',
    logicalResolution: LogicalResolution(
      height: 1024,
      width: 768,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'android-htc-one-m9',
    name: 'HTC One M9',
    logicalResolution: LogicalResolution(
      height: 640,
      width: 360,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-google-pixel',
    name: 'Google Pixel',
    logicalResolution: LogicalResolution(
      height: 732,
      width: 412,
    ),
    devicePixelRatio: 2.6,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s8',
    name: 'Samsung Galaxy S8',
    logicalResolution: LogicalResolution(
      height: 740,
      width: 360,
    ),
    devicePixelRatio: 4.0,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-tab-10',
    name: 'Samsung Galaxy Tab 10',
    logicalResolution: LogicalResolution(
      height: 1280,
      width: 800,
    ),
    devicePixelRatio: 1.0,
    targetPlatform: TargetPlatform.android,
  ),
];
