import 'package:flutter/material.dart';
import 'package:monarch_controller/data/abstract_channel_methods_sender.dart';
import 'package:monarch_controller/data/channel_methods.dart';
import 'package:monarch_controller/data/device_definitions.dart';
import 'package:monarch_controller/data/logical_resolution.dart';
import 'package:monarch_controller/data/monarch_data.dart';

final mockChannelMethodsSender = MockChannelMethodsSender();

class MockChannelMethodsSender implements AbstractChannelMethodsSender {
  @override
  void loadStory(String storyKey) {}

  @override
  void resetStory() {}

  @override
  void sendReadySignalAck() {}

  @override
  Future sendToggleVisualDebugFlag(OutboundChannelArgument visualDebugFlag) =>
      Future.value();

  @override
  void setActiveDevice(String deviceId) {}

  @override
  void setActiveLocale(String locale) {}

  @override
  void setActiveTheme(String themeId) {}

  @override
  void setDockSide(String dock) {}

  @override
  void setStoryScale(double scale) {}

  @override
  void setTextScaleFactor(double scale) {}

  @override
  Future<bool> hotReload() => Future.value(true);

  @override
  void restartPreview() {}
}

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
];

const standardMetaThemes = [
  MetaTheme(
    id: '__material-light-theme__',
    name: 'Material Light Theme',
    isDefault: true,
  ),
  MetaTheme(
    id: '__material-dark-theme__',
    name: 'Material Dark Theme',
    isDefault: false,
  ),
];
