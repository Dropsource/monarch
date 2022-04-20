import 'package:flutter/foundation.dart';

import 'channel_argument.dart';
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

/// @GOTCHA: if you change the [defaultDeviceDefinition] here, make sure to
/// also change it in:
/// - controller/lib/window_controller/data/device_definitions.dart
/// 
/// Then, release a new monarch build.
///
/// Make sure to not delete a default device that is used in previous versions
/// of the controller. Otherwise, users running different versions may see
/// unexpected errors.
final defaultDeviceDefinition = iPhone13DeviceDefinition;

/// iOS logical resolutions can be found here:
/// - https://www.dimensions.com/collection/apple-ipad
/// - https://ios-resolution.com/
///
/// Android: Use this calculator to get logical resolutions and device pixel ratios:
/// - https://docs.google.com/spreadsheets/d/1b_Or8OKIorU3G1CfQJZrGBOX4l-H4VBDKQrUY5uoW3I/edit?usp=sharing
const deviceDefinitions = [
  iPhone13DeviceDefinition,
  DeviceDefinition(
    id: 'ios-iphone-13-mini',
    name: 'iPhone 13 Mini',
    logicalResolution: LogicalResolution(
      height: 812,
      width: 375,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-13-pro',
    name: 'iPhone 13 Pro',
    logicalResolution: LogicalResolution(
      height: 844,
      width: 390,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-13-pro-max',
    name: 'iPhone 13 Pro Max',
    logicalResolution: LogicalResolution(
      height: 926,
      width: 428,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-12',
    name: 'iPhone 12',
    logicalResolution: LogicalResolution(
      height: 844,
      width: 390,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: TargetPlatform.iOS,
  ),
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
    id: 'ios-ipad-9th-gen',
    name: 'iPad (9th generation)',
    logicalResolution: LogicalResolution(
      height: 1080,
      width: 810,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-pro-5th-gen-12.9in',
    name: 'iPad Pro (5th generation, 12.9")',
    logicalResolution: LogicalResolution(
      height: 1366,
      width: 1024,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: TargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-pro-5th-gen-11in',
    name: 'iPad Pro (5th generation, 11")',
    logicalResolution: LogicalResolution(
      height: 1194,
      width: 834,
    ),
    devicePixelRatio: 2.0,
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
    id: 'android-pixel-5a',
    name: 'Pixel 5a',
    logicalResolution: LogicalResolution(
      height: 925,
      width: 416,
    ),
    devicePixelRatio: 2.5,
    targetPlatform: TargetPlatform.android,
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
    id: 'android-oneplus-9-pro',
    name: 'OnePlus 9 Pro',
    logicalResolution: LogicalResolution(
      height: 980,
      width: 439,
    ),
    devicePixelRatio: 3.28,
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
    id: 'android-samsung-galaxy-s21-ultra',
    name: 'Samsung Galaxy S21 Ultra',
    logicalResolution: LogicalResolution(
      height: 994,
      width: 447,
    ),
    devicePixelRatio: 3.2,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s21',
    name: 'Samsung Galaxy S21',
    logicalResolution: LogicalResolution(
      height: 912,
      width: 410,
    ),
    devicePixelRatio: 2.6,
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
    id: 'android-moto-g-power-2021',
    name: 'Moto G Power (2021)',
    logicalResolution: LogicalResolution(
      height: 962,
      width: 433,
    ),
    devicePixelRatio: 1.66,
    targetPlatform: TargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-moto-g-power',
    name: 'Moto G Power (2020)',
    logicalResolution: LogicalResolution(
      height: 922,
      width: 433,
    ),
    devicePixelRatio: 2.49,
    targetPlatform: TargetPlatform.android,
  ),
];
