import 'package:monarch_utils/log.dart';

import 'channel_methods.dart';
import 'vm_service_client.dart';
import 'package:vm_service/vm_service.dart' as vm_service;
import 'channel_methods_sender.dart';

final _logger = Logger('VisualDebugFlags');

class VisualDebugFlag implements OutboundChannelArgument {
  final String name;
  final bool isEnabled;

  VisualDebugFlag(this.name, this.isEnabled);

  @override
  Map<String, dynamic> toStandardMap() {
    return {'name': name, 'isEnabled': isEnabled};
  }
}

class _Flags {
  static const slowAnimations = 'slowAnimations';
  static const showGuidelines = 'showGuidelines';
  static const showBaselines = 'showBaselines';
  static const highlightRepaints = 'highlightRepaints';
  static const highlightOversizedImages = 'highlightOversizedImages';
}

class _ExtensionMethods {
  static const timeDilation = 'ext.flutter.timeDilation';
  static const debugPaint = 'ext.flutter.debugPaint';
  static const debugPaintBaselinesEnabled =
      'ext.flutter.debugPaintBaselinesEnabled';
  static const repaintRainbow = 'ext.flutter.repaintRainbow';
  static const invertOversizedImages = 'ext.flutter.invertOversizedImages';
}

const _timeDilationDisabledValue = 1.0;
const _timeDilationEnabledValue = 5.0;

Future<void> toggleFlagViaVmServiceExtension(
    String name, bool isEnabled) async {
  switch (name) {
    case _Flags.slowAnimations:
      // As documented in the flutter/devtools code:
      // > The param name for a numeric service extension will be the last part
      // > of the extension name (ext.flutter.extensionName => extensionName).
      // File: https://github.com/flutter/devtools/blob/master/packages/devtools_app/lib/src/service_manager.dart
      // Method: _callServiceExtension
      await vmServiceClient
          .callServiceExtension(_ExtensionMethods.timeDilation, {
        'timeDilation':
            isEnabled ? _timeDilationEnabledValue : _timeDilationDisabledValue
      });
      break;

    case _Flags.showGuidelines:
      await vmServiceClient.callServiceExtension(
          _ExtensionMethods.debugPaint, {'enabled': isEnabled});
      break;
    case _Flags.showBaselines:
      await vmServiceClient.callServiceExtension(
          _ExtensionMethods.debugPaintBaselinesEnabled, {'enabled': isEnabled});
      break;
    case _Flags.highlightRepaints:
      await vmServiceClient.callServiceExtension(
          _ExtensionMethods.repaintRainbow, {'enabled': isEnabled});
      break;
    case _Flags.highlightOversizedImages:
      await vmServiceClient.callServiceExtension(
          _ExtensionMethods.invertOversizedImages, {'enabled': isEnabled});
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
        case _ExtensionMethods.timeDilation:
          var time = double.parse(value);
          channelMethodsSender.sendToggleVisualDebugFlag(VisualDebugFlag(
              _Flags.slowAnimations, time > _timeDilationDisabledValue));
          break;

        case _ExtensionMethods.debugPaint:
          channelMethodsSender.sendToggleVisualDebugFlag(
              VisualDebugFlag(_Flags.showGuidelines, value == $true));
          break;
        case _ExtensionMethods.debugPaintBaselinesEnabled:
          channelMethodsSender.sendToggleVisualDebugFlag(
              VisualDebugFlag(_Flags.showBaselines, value == $true));
          break;
        case _ExtensionMethods.repaintRainbow:
          channelMethodsSender.sendToggleVisualDebugFlag(
              VisualDebugFlag(_Flags.highlightRepaints, value == $true));
          break;
        case _ExtensionMethods.invertOversizedImages:
          channelMethodsSender.sendToggleVisualDebugFlag(
              VisualDebugFlag(_Flags.highlightOversizedImages, value == $true));
          break;

        default:
        // no-op
      }
    }
  } catch (e, s) {
    _logger.warning('Error while handling VmService extension event', e, s);
  }
}
