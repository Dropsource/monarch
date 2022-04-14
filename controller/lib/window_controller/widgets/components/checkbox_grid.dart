import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/dev_tools_option.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';

class CheckboxGrid extends StatelessWidget {
  final List<DevToolsOption> devToolsOptions;
  final Set<DevToolFeature> enabledFeatures;
  final Function(DevToolsOption)? onOptionToggle;

  const CheckboxGrid({
    Key? key,
    required this.devToolsOptions,
    required this.enabledFeatures,
    this.onOptionToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 8.0),
        itemCount: devToolsOptions.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final item = devToolsOptions[index];
          return CheckboxListTile(
            dense: true,
            title: TextBody1(
              item.label,
              shouldTranslate: true,
            ),
            value: enabledFeatures.contains(item.feature),
            onChanged: (newValue) => onOptionToggle?.call(item),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.only(left: 60),
          );
        });
  }
}
