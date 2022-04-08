import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/checkbox_grid.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/dropdown.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/labeled_control.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/numbered_slider.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';

import '../../../main.dart';

class ControlsPanel extends StatelessWidget {
  final ConnectedWindowControllerState state;
  final double width;

  const ControlsPanel({
    required this.state,
    Key? key,
    this.width = 353,
  }) : super(key: key);
  static const controlWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
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
          LabeledControl(
            label: 'Text Scale Factor',
            control: const NumberedSlider(),
            controlWidth: controlWidth,
          ),
          Divider(
            thickness: 1.0,
            height: 10,
            color: Colors.white.withAlpha(100),
          ),
          LabeledControl(
            label: 'Scale',
            control: DropDown<String>(
              currentValue: state.currentScale,
              values: state.scaleList.toList(),
              toStringFunction: (e) => e,
            ),
            controlWidth: controlWidth,
          ),
          LabeledControl(
            label: 'Dock',
            control: DropDown<String>(
              currentValue: state.currentDock,
              values: state.dockList.toList(),
              toStringFunction: (e) => e,
            ),
            controlWidth: controlWidth,
          ),
          Divider(
            thickness: 1.0,
            height: 10,
            color: Colors.white.withAlpha(100),
          ),
          CheckboxGrid(
            devToolsOptions: state.devToolOptions,
            enabledFeatures: state.enabledDevToolsFeatures,
          ),
          MaterialButton(
            color: Colors.red,
            onPressed: () {},
            child: const Text('Launch DevTools...'),
          ),
        ],
      ),
    );
  }
}
