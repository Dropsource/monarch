import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:monarch_window_controller/window_controller/data/dev_tools_option.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import 'checkbox_list_tile.dart';

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
    return Expanded(
      // width: 200,
      // height: 200,
      child: AlignedGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: devToolsOptions.length,
          itemBuilder: (context, index) {
            final item = devToolsOptions[index];
            return StockholmCheckbox(
              value: enabledFeatures.contains(item.feature),
              onChanged: (newValue) => onOptionToggle?.call(item),
              label: Translations.of(context)!.text(item.label),
            );
          }),
    );
    // return StaggeredGridView.(
    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 2, childAspectRatio: 3.5),
    //     itemCount: devToolsOptions.length,
    //     shrinkWrap: true,
    //     itemBuilder: (BuildContext context, int index) {
    //       final item = devToolsOptions[index];
    //       return Container(
    //         child: StockholmCheckbox(value: enabledFeatures.contains(item.feature),
    //         onChanged: (newValue) => onOptionToggle?.call(item),
    //           label: Translations.of(context)!.text(item.label),
    //         )
    // CustomCheckboxListTile(
    //   dense: true,
    //   title: TextBody1(
    //     item.label,
    //     shouldTranslate: true,
    //   ),
    //   minLeadingWidth: 0,
    //   value: enabledFeatures.contains(item.feature),
    //   onChanged: (newValue) => onOptionToggle?.call(item),
    //   contentPadding: EdgeInsets.zero,
    //
    //   controlAffinity: ListTileControlAffinity.leading,
    // ),
    //   );
    // });
  }
}
