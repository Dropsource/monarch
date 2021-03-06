import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'dart:ui' as ui;

import 'active_device.dart';
import 'device_definitions.dart';
import 'active_text_scale_factor.dart';

class MonarchBinding extends BindingBase
    with
        GestureBinding,
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        SemanticsBinding,
        RendererBinding,
        WidgetsBinding {
  MonarchBinding() {
    _onDeviceChanged(activeDevice.value);
    _onTextScaleFactorChanged(activeTextScaleFactor.value);

    activeDevice.stream.listen(_onDeviceChanged);
    activeTextScaleFactor.stream.listen(_onTextScaleFactorChanged);
  }

  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) {
      MonarchBinding();
    }
    assert(WidgetsBinding.instance is MonarchBinding);
    return WidgetsBinding.instance!;
  }

  @override
  TestWindow get window => _window;
  final _window = TestWindow(window: ui.window);

  void _onDeviceChanged(DeviceDefinition device) {
    window.physicalSizeTestValue = Size(
        device.logicalResolution.width * window.devicePixelRatio,
        device.logicalResolution.height * window.devicePixelRatio);
  }

  void _onTextScaleFactorChanged(double factor) {
    window.textScaleFactorTestValue = factor;
  }
}
