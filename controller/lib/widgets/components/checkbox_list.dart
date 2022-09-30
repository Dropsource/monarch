import 'package:flutter/material.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import '../../data/visual_debug_flag_ui.dart';

class CheckboxList extends StatelessWidget {
  final List<VisualDebugFlagUi> visualDebugFlags;
  final Function(VisualDebugFlagUi)? onFlagToggled;

  const CheckboxList({
    Key? key,
    required this.visualDebugFlags,
    this.onFlagToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: visualDebugFlags
          .map((item) => SizedBox(
              height: 20,
              child: StockholmCheckbox(
                value: item.isEnabled,
                onChanged: (newValue) {
                  onFlagToggled?.call(item);
                },
                label: Translations.of(context)!.text(item.label),
              )))
          .toList(),
    );
  }
}
