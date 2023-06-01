import 'package:monarch_definitions/monarch_definitions.dart';

/// iOS logical resolutions can be found here:
/// - https://www.dimensions.com/collection/apple-ipad
/// - https://ios-resolution.com/
///
/// Android: Use this calculator to get logical resolutions and device pixel ratios:
/// - https://docs.google.com/spreadsheets/d/1b_Or8OKIorU3G1CfQJZrGBOX4l-H4VBDKQrUY5uoW3I/edit?usp=sharing
const deviceDefinitions = [
  DeviceDefinition(
    id: 'ios-iphone-14',
    name: 'iPhone 14',
    logicalResolution: LogicalResolution(
      height: 844,
      width: 390,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-14-plus',
    name: 'iPhone 14 Plus',
    logicalResolution: LogicalResolution(
      height: 926,
      width: 428,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-14-pro',
    name: 'iPhone 14 Pro',
    logicalResolution: LogicalResolution(
      height: 852,
      width: 393,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-14-pro-max',
    name: 'iPhone 14 Pro Max',
    logicalResolution: LogicalResolution(
      height: 932,
      width: 430,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),

  DeviceDefinition(
    id: 'ios-iphone-13',
    name: 'iPhone 13',
    logicalResolution: LogicalResolution(
      height: 844,
      width: 390,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
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
  DeviceDefinition(
    id: 'ios-iphone-12-pro-max',
    name: 'iPhone 12 Pro Max',
    logicalResolution: LogicalResolution(
      height: 926,
      width: 428,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-11',
    name: 'iPhone 11',
    logicalResolution: LogicalResolution(
      height: 896,
      width: 414,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-11-pro',
    name: 'iPhone 11 Pro',
    logicalResolution: LogicalResolution(
      height: 812,
      width: 375,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-11-pro-max',
    name: 'iPhone 11 Pro Max',
    logicalResolution: LogicalResolution(
      height: 896,
      width: 414,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-se-3rd-gen',
    name: 'iPhone SE (3rd generation)',
    logicalResolution: LogicalResolution(
      height: 667,
      width: 375,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-iphone-se-2nd-gen',
    name: 'iPhone SE (2nd generation)',
    logicalResolution: LogicalResolution(
      height: 667,
      width: 375,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  
  DeviceDefinition(
      id: 'ios-ipad-10th-gen',
      name: 'iPad (10th generation)',
      logicalResolution: LogicalResolution(
        height: 1180,
        width: 820,
      ),
      devicePixelRatio: 2.0,
      targetPlatform: MonarchTargetPlatform.iOS),
  DeviceDefinition(
    id: 'ios-ipad-9th-gen',
    name: 'iPad (9th generation)',
    logicalResolution: LogicalResolution(
      height: 1080,
      width: 810,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-8th-gen',
    name: 'iPad (8th generation)',
    logicalResolution: LogicalResolution(
      height: 1080,
      width: 810,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-7th-gen',
    name: 'iPad (7th generation)',
    logicalResolution: LogicalResolution(
      height: 1080,
      width: 810,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-air-5th-gen',
    name: 'iPad Air (5th generation)',
    logicalResolution: LogicalResolution(
      height: 1180,
      width: 820,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-air-4th-gen',
    name: 'iPad Air (4th generation)',
    logicalResolution: LogicalResolution(
      height: 1180,
      width: 820,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
      id: 'ios-ipad-pro-6th-gen-12.9in',
      name: 'iPad Pro (6th generation, 12.9")',
      logicalResolution: LogicalResolution(
        height: 1366,
        width: 1024,
      ),
      devicePixelRatio: 2.0,
      targetPlatform: MonarchTargetPlatform.iOS),
  DeviceDefinition(
      id: 'ios-ipad-pro-6th-gen-11in',
      name: 'iPad Pro (6th generation, 11")',
      logicalResolution: LogicalResolution(
        height: 1194,
        width: 834,
      ),
      devicePixelRatio: 2.0,
      targetPlatform: MonarchTargetPlatform.iOS),
  DeviceDefinition(
    id: 'ios-ipad-pro-5th-gen-12.9in',
    name: 'iPad Pro (5th generation, 12.9")',
    logicalResolution: LogicalResolution(
      height: 1366,
      width: 1024,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-pro-5th-gen-11in',
    name: 'iPad Pro (5th generation, 11")',
    logicalResolution: LogicalResolution(
      height: 1194,
      width: 834,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),  
  DeviceDefinition(
    id: 'ios-ipad-pro-4th-gen',
    name: 'iPad Pro (4th generation, 11")',
    logicalResolution: LogicalResolution(
      height: 1194,
      width: 834,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),
  DeviceDefinition(
    id: 'ios-ipad-mini-5th-gen',
    name: 'iPad Mini (5th generation)',
    logicalResolution: LogicalResolution(
      height: 1024,
      width: 768,
    ),
    devicePixelRatio: 2.0,
    targetPlatform: MonarchTargetPlatform.iOS,
  ),

  /// Google Pixel 7
  /// Google Pixel 7a
  /// Google Pixel 7 Pro
  /// Google Pixel 6
  /// Google Pixel 6a
  /// Google Pixel 6 Pro
  /// Samsung Galaxy S23
  /// Samsung Galaxy S23 Plus
  /// Samsung Galaxy S23 Ultra
  /// Samsung Galaxy S22
  /// Samsung Galaxy A54 5G
  /// Asus ZenFone 9
  /// OnePlus 11
  /// OnePlus 10 Pro

  DeviceDefinition(
    id: 'android-pixel-7',
    name: 'Google Pixel 7',
    logicalResolution: LogicalResolution(
      height: 923,
      width: 415,
    ),
    devicePixelRatio: 2.6,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-pixel-7a',
    name: 'Google Pixel 7a',
    logicalResolution: LogicalResolution(
      height: 891,
      width: 401,
    ),
    devicePixelRatio: 2.7,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-pixel-7-pro',
    name: 'Google Pixel 7 Pro',
    logicalResolution: LogicalResolution(
      height: 975,
      width: 450,
    ),
    devicePixelRatio: 3.2,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'android-pixel-6',
    name: 'Google Pixel 6',
    logicalResolution: LogicalResolution(
      height: 934,
      width: 420,
    ),
    devicePixelRatio: 2.6,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-pixel-6a',
    name: 'Google Pixel 6a',
    logicalResolution: LogicalResolution(
      height: 895,
      width: 403,
    ),
    devicePixelRatio: 2.7,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-pixel-6-pro',
    name: 'Google Pixel 6 Pro',
    logicalResolution: LogicalResolution(
      height: 975,
      width: 450,
    ),
    devicePixelRatio: 3.2,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'android-pixel-5a',
    name: 'Google Pixel 5a',
    logicalResolution: LogicalResolution(
      height: 925,
      width: 416,
    ),
    devicePixelRatio: 2.5,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-pixel-5',
    name: 'Google Pixel 5',
    logicalResolution: LogicalResolution(
      height: 867,
      width: 400,
    ),
    devicePixelRatio: 2.7,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-pixel-4a',
    name: 'Google Pixel 4a',
    logicalResolution: LogicalResolution(
      height: 845,
      width: 390,
    ),
    devicePixelRatio: 2.7,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'android-samsung-galaxy-s23',
    name: 'Samsung Galaxy S23',
    logicalResolution: LogicalResolution(
      height: 881,
      width: 407,
    ),
    devicePixelRatio: 2.65,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s23-plus',
    name: 'Samsung Galaxy S23 Plus',
    logicalResolution: LogicalResolution(
      height: 953,
      width: 440,
    ),
    devicePixelRatio: 2.45,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s23-ultra',
    name: 'Samsung Galaxy S23 Ultra',
    logicalResolution: LogicalResolution(
      height: 988,
      width: 461,
    ),
    devicePixelRatio: 3.13,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'android-samsung-galaxy-s22',
    name: 'Samsung Galaxy S22',
    logicalResolution: LogicalResolution(
      height: 881,
      width: 407,
    ),
    devicePixelRatio: 2.65,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s22-plus',
    name: 'Samsung Galaxy S22 Plus',
    logicalResolution: LogicalResolution(
      height: 953,
      width: 440,
    ),
    devicePixelRatio: 2.45,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s22-ultra',
    name: 'Samsung Galaxy S22 Ultra',
    logicalResolution: LogicalResolution(
      height: 988,
      width: 461,
    ),
    devicePixelRatio: 3.13,
    targetPlatform: MonarchTargetPlatform.android,
  ),


  DeviceDefinition(
    id: 'android-samsung-galaxy-s21',
    name: 'Samsung Galaxy S21',
    logicalResolution: LogicalResolution(
      height: 912,
      width: 410,
    ),
    devicePixelRatio: 2.6,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s21-ultra',
    name: 'Samsung Galaxy S21 Ultra',
    logicalResolution: LogicalResolution(
      height: 994,
      width: 447,
    ),
    devicePixelRatio: 3.2,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-s20-plus',
    name: 'Samsung Galaxy S20 Plus',
    logicalResolution: LogicalResolution(
      height: 975,
      width: 438,
    ),
    devicePixelRatio: 3.28,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'android-samsung-galaxy-a54-5g',
    name: 'Samsung Galaxy A54 5G',
    logicalResolution: LogicalResolution(
      height: 929,
      width: 429,
    ),
    devicePixelRatio: 2.5,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'android-samsung-galaxy-note-20-ultra',
    name: 'Samsung Galaxy Note 20 Ultra',
    logicalResolution: LogicalResolution(
      height: 998,
      width: 465,
    ),
    devicePixelRatio: 3.0,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-samsung-galaxy-note-20',
    name: 'Samsung Galaxy Note 20',
    logicalResolution: LogicalResolution(
      height: 977,
      width: 439,
    ),
    devicePixelRatio: 2.45,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'asus-zenfone-9',
    name: 'Asus ZenFone 9',
    logicalResolution: LogicalResolution(
      height: 863,
      width: 388,
    ),
    devicePixelRatio: 2.78,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'android-oneplus-11',
    name: 'OnePlus 11',
    logicalResolution: LogicalResolution(
      height: 980,
      width: 439,
    ),
    devicePixelRatio: 3.28,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-oneplus-10-pro',
    name: 'OnePlus 10 Pro',
    logicalResolution: LogicalResolution(
      height: 980,
      width: 439,
    ),
    devicePixelRatio: 3.28,
    targetPlatform: MonarchTargetPlatform.android,
  ),

  DeviceDefinition(
    id: 'android-oneplus-9-pro',
    name: 'OnePlus 9 Pro',
    logicalResolution: LogicalResolution(
      height: 980,
      width: 439,
    ),
    devicePixelRatio: 3.28,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-oneplus-8-pro',
    name: 'OnePlus 8 Pro',
    logicalResolution: LogicalResolution(
      height: 988,
      width: 449,
    ),
    devicePixelRatio: 3.2,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  
  DeviceDefinition(
    id: 'android-moto-g-power-2021',
    name: 'Moto G Power (2021)',
    logicalResolution: LogicalResolution(
      height: 962,
      width: 433,
    ),
    devicePixelRatio: 1.66,
    targetPlatform: MonarchTargetPlatform.android,
  ),
  DeviceDefinition(
    id: 'android-moto-g-power',
    name: 'Moto G Power (2020)',
    logicalResolution: LogicalResolution(
      height: 922,
      width: 433,
    ),
    devicePixelRatio: 2.49,
    targetPlatform: MonarchTargetPlatform.android,
  ),
];
