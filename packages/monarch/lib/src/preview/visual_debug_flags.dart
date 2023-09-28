import 'package:vm_service/vm_service.dart' as vm_service;
import 'package:monarch_utils/log.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'vm_service_client.dart';
import 'channel_methods_sender.dart';

final _logger = Logger('VisualDebugFlags');

Future<void> toggleFlagViaVmServiceExtension(
    String name, bool isEnabled) async {
  switch (name) {
    case VisualDebugFlags.slowAnimations:
      // As documented in the flutter/devtools code:
      // > The param name for a numeric service extension will be the last part
      // > of the extension name (ext.flutter.extensionName => extensionName).
      // File: https://github.com/flutter/devtools/blob/master/packages/devtools_app/lib/src/service_manager.dart
      // Method: _callServiceExtension
      await vmServiceClient
          .callServiceExtension(VisualDebugExtensionMethods.timeDilation, {
        'timeDilation': isEnabled
            ? VisualDebugTimeDilationValues.enabledValue
            : VisualDebugTimeDilationValues.disabledValue
      });
      break;

    case VisualDebugFlags.showGuidelines:
      await vmServiceClient.callServiceExtension(
          VisualDebugExtensionMethods.debugPaint, {'enabled': isEnabled});
      break;
    case VisualDebugFlags.showBaselines:
      await vmServiceClient.callServiceExtension(
          VisualDebugExtensionMethods.debugPaintBaselinesEnabled,
          {'enabled': isEnabled});
      break;
    case VisualDebugFlags.highlightRepaints:
      await vmServiceClient.callServiceExtension(
          VisualDebugExtensionMethods.repaintRainbow, {'enabled': isEnabled});
      break;
    case VisualDebugFlags.highlightOversizedImages:
      await vmServiceClient.callServiceExtension(
          VisualDebugExtensionMethods.invertOversizedImages,
          {'enabled': isEnabled});
      break;

    case VisualDebugFlags.performanceOverlay:
      await vmServiceClient.callServiceExtension(
          VisualDebugExtensionMethods.performanceOverlay,
          {'enabled': isEnabled});
      break;

    default:
      throw 'Unexpected visual debug flag name, got $name';
  }
}

/// Handles VmService Extension Events which may be triggered by devtools.
/// We only care about visual debugging events.
///
/// Sample event.json!['extensionData']:
/// {extension: ext.flutter.debugPaint, value: false} --show guidelines
/// {extension: ext.flutter.timeDilation, value: 5.0}  --slow animations ON
/// {extension: ext.flutter.timeDilation, value: 1.0}  --slow animations OFF
/// {extension: ext.flutter.debugPaintBaselinesEnabled, value: true} -- show baselines
/// {extension: ext.flutter.repaintRainbow, value: true} --highlight repaints
/// {extension: ext.flutter.invertOversizedImages, value: true} --highlight oversized images
///
/// You can find similar code in the devtools_app source code, ServiceManager._handleExtensionEvent:
/// https://github.com/flutter/devtools/blob/master/packages/devtools_app/lib/src/service_manager.dart
void handleVmServiceExtensionEvent(vm_service.Event event) {
  try {
    if (event.extensionKind == 'Flutter.ServiceExtensionStateChanged') {
      var extension = event.json!['extensionData']['extension'].toString();
      var value = event.json!['extensionData']['value'].toString();

      var $true = 'true';

      switch (extension) {
        case VisualDebugExtensionMethods.timeDilation:
          var time = double.parse(value);
          channelMethodsSender.sendToggleVisualDebugFlag(VisualDebugFlag(
              name: VisualDebugFlags.slowAnimations,
              isEnabled: time > VisualDebugTimeDilationValues.disabledValue));
          break;

        case VisualDebugExtensionMethods.debugPaint:
          channelMethodsSender.sendToggleVisualDebugFlag(VisualDebugFlag(
              name: VisualDebugFlags.showGuidelines,
              isEnabled: value == $true));
          break;
        case VisualDebugExtensionMethods.debugPaintBaselinesEnabled:
          channelMethodsSender.sendToggleVisualDebugFlag(VisualDebugFlag(
              name: VisualDebugFlags.showBaselines, isEnabled: value == $true));
          break;
        case VisualDebugExtensionMethods.repaintRainbow:
          channelMethodsSender.sendToggleVisualDebugFlag(VisualDebugFlag(
              name: VisualDebugFlags.highlightRepaints,
              isEnabled: value == $true));
          break;
        case VisualDebugExtensionMethods.invertOversizedImages:
          channelMethodsSender.sendToggleVisualDebugFlag(VisualDebugFlag(
              name: VisualDebugFlags.highlightOversizedImages,
              isEnabled: value == $true));
          break;
        case VisualDebugExtensionMethods.performanceOverlay:
          channelMethodsSender.sendToggleVisualDebugFlag(VisualDebugFlag(
              name: VisualDebugFlags.performanceOverlay,
              isEnabled: value == $true));
          break;

        default:
        // no-op
      }
    }
  } catch (e, s) {
    _logger.warning('Error while handling VmService extension event', e, s);
  }
}
