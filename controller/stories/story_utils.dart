import 'package:monarch_definitions/monarch_definitions.dart';

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
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-13-pro',
    name: 'iPhone 13 Pro',
    logicalResolution: LogicalResolution(
      height: 844,
      width: 390,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-13-pro-max',
    name: 'iPhone 13 Pro Max',
    logicalResolution: LogicalResolution(
      height: 926,
      width: 428,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-12',
    name: 'iPhone 12',
    logicalResolution: LogicalResolution(
      height: 844,
      width: 390,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-12-mini',
    name: 'iPhone 12 Mini',
    logicalResolution: LogicalResolution(
      height: 780,
      width: 360,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-12-pro',
    name: 'iPhone 12 Pro',
    logicalResolution: LogicalResolution(
      height: 844,
      width: 390,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
];

const standardMetaThemes = [
  MetaThemeDefinition(
    id: '__material-light-theme__',
    name: 'Material Light Theme',
    isDefault: true,
  ),
  MetaThemeDefinition(
    id: '__material-dark-theme__',
    name: 'Material Dark Theme',
    isDefault: false,
  ),
];
