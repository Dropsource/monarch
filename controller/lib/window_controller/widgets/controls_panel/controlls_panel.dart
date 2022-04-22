import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/dock_definition.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';
import 'package:monarch_window_controller/window_controller/data/story_scale_definitions.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/checkbox_grid.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/dropdown.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/labeled_control.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/numbered_slider.dart';
import 'package:monarch_window_controller/window_controller/window_controller_manager.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import '../../data/device_definitions.dart';
import '../components/text.dart';

class ControlsPanel extends StatelessWidget {
  final WindowControllerState state;
  final double width;
  final dividerHeight = 24.0;
  final WindowControllerManager manager;

  const ControlsPanel({
    required this.state,
    required this.manager,
    Key? key,
    this.width = 353,
  }) : super(key: key);
  static const controlWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    final _translations = Translations.of(context)!;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 8,
          ),
          LabeledControl(
            label: 'controls.device',
            control: DropDown<DeviceDefinition>(
              currentValue: state.currentDevice,
              values: state.devices,
              toStringFunction: (e) => e.name,
            ),
            controlWidth: controlWidth,
          ),
          const SizedBox(
            height: 8,
          ),
          LabeledControl(
            label: 'controls.theme',
            control: DropDown<MetaTheme>(
              currentValue: state.currentTheme,
              values: state.monarchData.metaThemes,
              toStringFunction: (e) => e.name,
            ),
            controlWidth: controlWidth,
          ),
          const SizedBox(
            height: 8,
          ),
          LabeledControl(
            label: 'controls.locale',
            control: DropDown<Locale>(
              currentValue: state.currentLocale,
              values: state.monarchData.allLocales.toList(),
              toStringFunction: (e) => e.toString(),
            ),
            controlWidth: controlWidth,
          ),
          LabeledControl(
            label:
                '${_translations.text("controls.text_scale_factor")} (${state.textScaleFactor.toStringAsFixed(1)})',
            control: NumberedSlider(
              initialValue: state.textScaleFactor,
              onChanged: (val) => manager.onTextScaleFactorChanged(val),
            ),
            shouldTranslate: false,
            controlWidth: controlWidth,
          ),
          Divider(
            thickness: 1.0,
            height: dividerHeight,
            color: Colors.white.withAlpha(100),
          ),
          LabeledControl(
            label: 'controls.scale',
            control: DropDown<StoryScaleDefinition>(
              currentValue: state.currentScale,
              values: state.scaleList.toList(),
              toStringFunction: (e) => e.name,
            ),
            controlWidth: controlWidth,
          ),
          const SizedBox(
            height: 8,
          ),
          LabeledControl(
            label: 'controls.dock',
            control: DropDown<DockDefinition>(
              currentValue: state.currentDock,
              values: state.dockList.toList(),
              toStringFunction: (e) => _translations.text(e.name),
            ),
            controlWidth: controlWidth,
          ),
          Divider(
            thickness: 1.0,
            height: dividerHeight,
            color: Colors.white.withAlpha(100),
          ),
          CheckboxGrid(
            devToolsOptions: state.devToolOptions,
            enabledFeatures: state.enabledDevToolsFeatures,
            onOptionToggle: manager.onDevToolOptionToggled,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: SizedBox(
              width: 120,
              child: StockholmButton(
                onPressed: () {},
                child:
                    const TextBody1('dev_tools.launch', shouldTranslate: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
