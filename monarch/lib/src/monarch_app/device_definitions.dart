import 'package:flutter/foundation.dart';

import 'channel_methods.dart';
import 'logical_resolution.dart';

const String _ios = 'ios';
const String _android = 'android';

String? targetPlatformToString(TargetPlatform platform) {
  return platform == TargetPlatform.iOS
      ? _ios
      : platform == TargetPlatform.android
          ? _android
          : null;
}

TargetPlatform? targetPlatformFromString(String platform) {
  return platform == _ios
      ? TargetPlatform.iOS
      : platform == _android
          ? TargetPlatform.android
          : null;
}

class DeviceDefinition implements OutboundChannelArgument {
  const DeviceDefinition({
    required this.id,
    required this.name,
    required this.logicalResolution,
    required this.devicePixelRatio,
    required this.targetPlatform,
  });
  final String id, name;
  final TargetPlatform targetPlatform;
  final LogicalResolution logicalResolution;

  /// Also called: Retina factor, UIKit Scale factor, etc.
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

const iPhone12DeviceDefinition = DeviceDefinition(
  id: 'ios-iphone-12',
  name: 'iPhone 12',
  logicalResolution: LogicalResolution(
    height: 844,
    width: 390,
  ),
  devicePixelRatio: 3.0,
  targetPlatform: TargetPlatform.iOS,
);

/// @GOTCHA: if you change the [defaultDeviceDefinition] here, make sure to
/// also change it in:
/// - monarch_mac_app/monarch/monarch/DeviceDefinition.swift
/// - monarch_windows_app/device_definition.cpp
/// Then, release mac and windows builds.
final defaultDeviceDefinition = iPhone12DeviceDefinition;

/// iOS logical resolutions can be found here:
/// - https://www.dimensions.com/collection/apple-ipad
/// - https://ios-resolution.com/
///
/// Android: Use this calculator to get logical resolutions and device pixel ratios:
/// - https://docs.google.com/spreadsheets/d/1b_Or8OKIorU3G1CfQJZrGBOX4l-H4VBDKQrUY5uoW3I/edit?usp=sharing
const deviceDefinitions = [
  iPhone12DeviceDefinition,
  DeviceDefinition(
    id: 'ios-iphone-12-mini',
    name: 'iPhone 12 Mini',
    logicalResolution: LogicalResolution(
      height: 780,
      width: 360,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-12-pro',
    name: 'iPhone 12 Pro',
    logicalResolution: LogicalResolution(
      height: 844,
      width: 390,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-12-pro-max',
    name: 'iPhone 12 Pro Max',
    logicalResolution: LogicalResolution(
      height: 926,
      width: 428,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-se-2nd-gen',
    name: 'iPhone SE (2nd generation)',
    logicalResolution: LogicalResolution(
      height: 667,
      width: 375,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-11',
    name: 'iPhone 11',
    logicalResolution: LogicalResolution(
      height: 896,
      width: 414,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-11-pro',
    name: 'iPhone 11 Pro',
    logicalResolution: LogicalResolution(
      height: 812,
      width: 375,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-11-pro-max',
    name: 'iPhone 11 Pro Max',
    logicalResolution: LogicalResolution(
      height: 896,
      width: 414,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-xr',
    name: 'iPhone XR',
    logicalResolution: LogicalResolution(
      height: 896,
      width: 414,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-x',
    name: 'iPhone X',
    logicalResolution: LogicalResolution(
      height: 812,
      width: 375,
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
    id: 'ios-ipad-air-4th-gen',
    name: 'iPad Air (4th generation)',
    logicalResolution: LogicalResolution(
      height: 1180,
      width: 820,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-8th-gen',
    name: 'iPad (8th generation)',
    logicalResolution: LogicalResolution(
      height: 1080,
      width: 810,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-pro-4th-gen',
    name: 'iPad Pro (4th generation, 11")',
    logicalResolution: LogicalResolution(
      height: 1194,
      width: 834,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-7th-gen',
    name: 'iPad (7th generation)',
    logicalResolution: LogicalResolution(
      height: 1080,
      width: 810,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-mini-5th-gen',
    name: 'iPad Mini (5th generation)',
    logicalResolution: LogicalResolution(
      height: 1024,
      width: 768,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'android-pixel-5',
    name: 'Pixel 5',
    logicalResolution: LogicalResolution(
      height: 867,
      width: 400,
    ),
    devicePixelRatio: 2.7,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-pixel-4a',
    name: 'Pixel 4a',
    logicalResolution: LogicalResolution(
      height: 845,
      width: 390,
    ),
    devicePixelRatio: 2.7,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-note-20-ultra',
    name: 'Samsung Galaxy Note 20 Ultra',
    logicalResolution: LogicalResolution(
      height: 998,
      width: 465,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-note-20',
    name: 'Samsung Galaxy Note 20',
    logicalResolution: LogicalResolution(
      height: 977,
      width: 439,
    ),
    devicePixelRatio: 2.45,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-oneplus-8-pro',
    name: 'OnePlus 8 Pro',
    logicalResolution: LogicalResolution(
      height: 988,
      width: 449,
    ),
    devicePixelRatio: 3.2,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s20-plus',
    name: 'Samsung Galaxy S20 Plus',
    logicalResolution: LogicalResolution(
      height: 975,
      width: 438,
    ),
    devicePixelRatio: 3.28,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-moto-g-power',
    name: 'Moto G Powewr',
    logicalResolution: LogicalResolution(
      height: 922,
      width: 433,
    ),
    devicePixelRatio: 2.49,
    targetPlatform: TargetPlatform.android,
  ),
];
