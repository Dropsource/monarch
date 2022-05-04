import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:monarch_window_controller/window_controller/data/visual_debug_flags.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import 'checkbox_list_tile.dart';

class CheckboxGrid extends StatelessWidget {
  final List<VisualDebugFlag> devToolsOptions;
  final Function(VisualDebugFlag)? onOptionToggle;

  const CheckboxGrid({
    Key? key,
    required this.devToolsOptions,
    this.onOptionToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 200,
      height: 60,
      child: AlignedGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: devToolsOptions.length,
          itemBuilder: (context, index) {
            final item = devToolsOptions[index];
            return StockholmCheckbox(
              value: item.isEnabled,
              onChanged: (newValue) => onOptionToggle?.call(item),
              label: Translations.of(context)!.text(item.label),
            );
          }),
    );
  }
}
