import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import '../../data/visual_debug_flags.dart';

class CheckboxGrid extends StatefulWidget {
  final List<VisualDebugFlag> devToolsOptions;
  final Function(VisualDebugFlag)? onOptionToggle;

  const CheckboxGrid({
    Key? key,
    required this.devToolsOptions,
    this.onOptionToggle,
  }) : super(key: key);

  @override
  State<CheckboxGrid> createState() => _CheckboxGridState();
}

class _CheckboxGridState extends State<CheckboxGrid> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: AlignedGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: widget.devToolsOptions.length,
          itemBuilder: (context, index) {
            final item = widget.devToolsOptions[index];
            return StockholmCheckbox(
              value: item.isEnabled,
              onChanged: (newValue) {
                widget.onOptionToggle?.call(item);
              },
              label: Translations.of(context)!.text(item.label),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
