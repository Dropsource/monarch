import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'active_device.dart';
import 'active_theme.dart';
import 'device_definitions.dart';

class StoryView extends StatefulWidget {
  final String storyKey;
  final Widget child;

  StoryView({this.storyKey, this.child});

  @override
  State<StatefulWidget> createState() {
    return _StoryViewState();
  }
}

class _StoryViewState extends State<StoryView> {
  DeviceDefinition _device;

  String _themeId;
  ThemeData _themeData;

  StreamSubscription _activeDeviceSubscription;
  StreamSubscription _activeThemeSubscription;

  _StoryViewState();

  @override
  void initState() {
    super.initState();

    _setDeviceDefinition();
    _activeDeviceSubscription = activeDevice.activeDeviceStream
        .listen((_) => setState(_setDeviceDefinition));

    _setThemeData();
    _activeThemeSubscription = activeTheme.activeMetaThemeStream
        .listen((_) => setState(_setThemeData));
  }

  void _setDeviceDefinition() {
    _device = activeDevice.activeDevice;
  }

  void _setThemeData() {
    _themeData = activeTheme.activeMetaTheme.theme;
    _themeId = activeTheme.activeMetaTheme.id;
  }

  @override
  void dispose() {
    _activeThemeSubscription?.cancel();
    _activeDeviceSubscription?.cancel();
    super.dispose();
  }

  String get keyValue => '${widget.storyKey}|$_themeId|${_device.id}';

  @override
  Widget build(BuildContext context) {
    ArgumentError.checkNotNull(_device, '_device');
    ArgumentError.checkNotNull(_themeId, '_themeId');
    ArgumentError.checkNotNull(_themeData, '_themeData');

    return Theme(
        key: ObjectKey(keyValue),
        data: _themeData.copyWith(platform: _device.targetPlatform),
        child: MediaQuery(
            data: MediaQueryData(
                size: Size(_device.logicalResolution.width,
                    _device.logicalResolution.height),
                devicePixelRatio: _device.devicePixelRatio),
            child: widget.child));
  }
}
