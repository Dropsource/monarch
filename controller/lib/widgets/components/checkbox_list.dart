import 'package:flutter/material.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import '../../data/visual_debug_flag_utils.dart';

class CheckboxList extends StatelessWidget {
  final Map<String, bool> visualDebugFlags;
  final Function(String, bool)? onFlagToggled;

  const CheckboxList({
    Key? key,
    required this.visualDebugFlags,
    this.onFlagToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: visualDebugFlags.entries.map((e) {
      var flagName = e.key;
      var isEnabled = e.value;
      return SizedBox(
          height: 20,
          child: StockholmCheckbox(
            value: isEnabled,
            onChanged: (newValue) {
              onFlagToggled?.call(flagName, isEnabled);
            },
            label: Translations.of(context)!
                .text(getVisualDebugFlagLabel(flagName)),
          ));
    }).toList());
  }
}
