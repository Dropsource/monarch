import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/dropdown.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/labeled_control.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/numbered_slider.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';

import '../../../main.dart';

class ControlsPanel extends StatelessWidget {
  final ConnectedWindowControllerState state;

  const ControlsPanel({required this.state, Key? key}) : super(key: key);
  static const controlWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        LabeledControl(
          label: 'Device',
          control: DropDown<String>(
            currentValue: state.currentDevice,
            values: state.devices,
            toStringFunction: (e) => e,
          ),
          controlWidth: controlWidth,
        ),
        LabeledControl(
          label: 'Theme',
          control: DropDown<MetaTheme>(
            currentValue: state.currentTheme,
            values: state.monarchData.metaThemes,
            toStringFunction: (e) => e.name,
          ),
          controlWidth: controlWidth,
        ),
        LabeledControl(
          label: 'Locale',
          control: DropDown<Locale>(
            currentValue: state.currentLocale,
            values: state.monarchData.allLocales.toList(),
            toStringFunction: (e) => e.toString(),
          ),
          controlWidth: controlWidth,
        ),
        // LabeledControl(
        //   label: 'Locale',
        //   control: SizedBox.shrink(),
        //   controlWidth: controlWidth,
        // ),
        LabeledControl(
          label: 'Text Scale Factor',
          control: NumberedSlider(),
          controlWidth: controlWidth,
        ),
      ],
    );
  }
}
