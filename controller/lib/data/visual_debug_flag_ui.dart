import 'package:monarch_definitions/monarch_definitions.dart';

class VisualDebugFlagUi extends VisualDebugFlag {
  final String label;
  final String toggled;

  VisualDebugFlagUi({
    required String name,
    bool isEnabled = false,
    required this.label,
    required this.toggled,
  }) : super(name: name, isEnabled: isEnabled);

  VisualDebugFlagUi copyWith({bool? enabled}) {
    return VisualDebugFlagUi(
      name: name,
      isEnabled: enabled ?? isEnabled,
      label: label,
      toggled: toggled,
    );
  }
}
