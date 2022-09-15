import 'package:flutter/material.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import '../../data/visual_debug_flags.dart';

class CheckboxList extends StatelessWidget {
  final List<VisualDebugFlag> visualDebugFlags;
  final Function(VisualDebugFlag)? onFlagToggled;

  const CheckboxList({
    Key? key,
    required this.visualDebugFlags,
    this.onFlagToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: visualDebugFlags
          .map((item) => StockholmCheckbox(
                value: item.isEnabled,
                onChanged: (newValue) {
                  onFlagToggled?.call(item);
                },
                label: Translations.of(context)!.text(item.label),
              ))
          .toList(),
    );

    // return SizedBox(
    //   height: 60,
    //   child: AlignedGridView.count(
    //       crossAxisCount: 2,
    //       mainAxisSpacing: 4,
    //       crossAxisSpacing: 4,
    //       itemCount: visualDebugFlags.length,
    //       itemBuilder: (context, index) {
    //         final item = visualDebugFlags[index];
    //         return StockholmCheckbox(
    //           value: item.isEnabled,
    //           onChanged: (newValue) {
    //             onFlagToggled?.call(item);
    //           },
    //           label: Translations.of(context)!.text(item.label),
    //         );
    //       }),
    // );
  }
}
