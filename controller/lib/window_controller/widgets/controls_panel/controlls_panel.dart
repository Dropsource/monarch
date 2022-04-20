import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/dock_definition.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';
import 'package:monarch_window_controller/window_controller/data/story_scale_definitions.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/checkbox_grid.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/dropdown.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/labeled_control.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/numbered_slider.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';

import '../../../utils/translations.dart';
import '../../data/device_definitions.dart';

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
    final _translations = Translations.of(context)!;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          LabeledControl(
            label: _translations.text('controls.device'),
            control: DropDown<DeviceDefinition>(
              currentValue: state.currentDevice,
              values: state.devices,
              toStringFunction: (e) => e.name,
            ),
            controlWidth: controlWidth,
          ),
          LabeledControl(
            label: _translations.text('controls.theme'),
            control: DropDown<MetaTheme>(
              currentValue: state.currentTheme,
              values: state.themes,
              toStringFunction: (e) => e.name,
            ),
            controlWidth: controlWidth,
          ),
          LabeledControl(
            label: _translations.text('controls.locale'),
            control: DropDown<String>(
              currentValue: state.currentLocale,
              values: state.locales,
              toStringFunction: (e) => e.toString(),
            ),
            controlWidth: controlWidth,
          ),
          LabeledControl(
            label: _translations.text('controls.text_scale_factor'),
            control: const NumberedSlider(),
            controlWidth: controlWidth,
          ),
          Divider(
            thickness: 1.0,
            height: 10,
            color: Colors.white.withAlpha(100),
          ),
          LabeledControl(
            label: _translations.text('controls.scale'),
            control: DropDown<StoryScaleDefinition>(
              currentValue: state.currentScale,
              values: state.scaleList.toList(),
              toStringFunction: (e) => e.name,
            ),
            controlWidth: controlWidth,
          ),
          LabeledControl(
            label: _translations.text('controls.dock'),
            control: DropDown<DockDefinition>(
              currentValue: state.currentDock,
              values: state.dockList.toList(),
              toStringFunction: (e) => _translations.text(e.name),
            ),
            controlWidth: controlWidth,
          ),
          Divider(
            thickness: 1.0,
            height: 10,
            color: Colors.white.withAlpha(100),
          ),
          // CheckboxGrid(
          //   devToolsOptions: state.devToolOptions,
          //   enabledFeatures: state.enabledDevToolsFeatures,
          // ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
              top: 40,
            ),
            child: MaterialButton(
              color: Colors.red,
              onPressed: () {},
              child: Text(_translations.text('dev_tools.launch')),
            ),
          ),
        ],
      ),
    );
  }
}
