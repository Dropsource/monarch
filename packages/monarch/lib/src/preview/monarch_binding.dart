import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:monarch_definitions/monarch_definitions.dart';

import 'active_device.dart';
import 'active_text_scale_factor.dart';

/// Similar to [WidgetsFlutterBinding].
class MonarchBinding extends BindingBase
    with
        GestureBinding,
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        SemanticsBinding,
        RendererBinding,
        WidgetsBinding {
  MonarchBinding()
      : platformDispatcher = TestPlatformDispatcher(
          platformDispatcher: PlatformDispatcher.instance,
        );

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;

    _onDeviceChanged(activeDevice.value);
    _onTextScaleFactorChanged(activeTextScaleFactor.value);

    activeDevice.stream.listen(_onDeviceChanged);
    activeTextScaleFactor.stream.listen(_onTextScaleFactorChanged);
  }

  static MonarchBinding get instance => BindingBase.checkInstance(_instance);
  static MonarchBinding? _instance;

  static MonarchBinding ensureInitialized() {
    if (MonarchBinding._instance == null) {
      MonarchBinding();
    }
    return MonarchBinding.instance;
  }

  @override
  final TestPlatformDispatcher platformDispatcher;

  void _onDeviceChanged(DeviceDefinition device) {
    var view = platformDispatcher.implicitView!;
    view.physicalSize = Size(
        device.logicalResolution.width * view.devicePixelRatio,
        device.logicalResolution.height * view.devicePixelRatio);
  }

  void _onTextScaleFactorChanged(double factor) {
    platformDispatcher.textScaleFactorTestValue = factor;
  }

  final _willReassembleStreamController = StreamController<void>.broadcast();
  Stream<void> get willReassembleStream =>
      _willReassembleStreamController.stream;

  @override
  Future<void> performReassemble() async {
    /// - Notify listeners of a hot reload.
    /// - Handlers should reload the project data and send it to the preview_api.
    /// - The preview_api will then compute new user selections based on the
    ///   new project data and send those selections back to the preview.
    /// - Those selections become the new active state.
    _willReassembleStreamController.add(null);

    /// - Call [WidgetsBinding.performReassemble] which should rebuild the
    ///   entire subtree under the [MonarchStoryApp] widget.
    await super.performReassemble();
  }

  /// Locks platform events (like mouse pointer or keyboard events) until the
  /// post-frame callbacks, which are called after the persistent callbacks,
  /// which is when the main rendering pipeline has been flushed.
  ///
  /// This function is meant to be called from a Widget's build function.
  ///
  /// We lock the platform events to make sure the
  /// stories are fully rendered before the user can interact with them.
  /// Otherwise, under some scenarios, widgets with inputs could throw
  /// "RenderBox was not laid out" if the platform sent events during
  /// initial layout and render.
  ///
  /// See also:
  ///
  ///  * [addPostFrameCallback]
  ///  * [SchedulerPhase], for the phases that SchedulerBinding can have.
  void lockEventsWhileRendering() {
    var completer = Completer();
    lockEvents(() => completer.future);
    addPostFrameCallback((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
  }

  void resetMouseTracker() {
    // ignore: invalid_use_of_visible_for_testing_member
    RendererBinding.instance.initMouseTracker();
  }
}
