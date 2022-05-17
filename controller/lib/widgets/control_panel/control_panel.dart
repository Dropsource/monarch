import 'package:flutter/material.dart';
import 'package:monarch_controller/data/dock_definition.dart';
import 'package:monarch_controller/data/monarch_data.dart';
import 'package:monarch_controller/data/story_scale_definitions.dart';
import 'package:monarch_controller/widgets/components/checkbox_grid.dart';
import 'package:monarch_controller/widgets/components/dropdown.dart';
import 'package:monarch_controller/widgets/components/labeled_control.dart';
import 'package:monarch_controller/widgets/components/numbered_slider.dart';
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/manager/controller_state.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import '../../data/device_definitions.dart';
import '../components/text.dart';

class ControlPanel extends StatelessWidget {
  final ControllerState state;
  final double width;
  final dividerHeight = 24.0;
  final ControllerManager manager;

  const ControlPanel({
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
              onChange: manager.onDeviceChanged,
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
              values: state.allThemes,
              toStringFunction: (e) => e.name,
              onChange: manager.onThemeChanged,
            ),
            controlWidth: controlWidth,
          ),
          const SizedBox(
            height: 8,
          ),
          LabeledControl(
            label: _translations.text('controls.locale'),
            shouldTranslate: false,
            control: DropDown<String>(
              currentValue: state.currentLocale,
              values: state.locales,
              toStringFunction: (e) => e.toString(),
              onChange: manager.onLocaleChanged,
            ),
            controlWidth: controlWidth,
          ),
          const SizedBox(
            height: 20,
          ),
          LabeledControl(
            label: _translations.text("controls.text_scale_factor"),
            control: NumberedSlider(
              initialValue: state.textScaleFactor,
              onChanged: manager.onTextScaleFactorChanged,
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
              onChange: manager.onScaleChanged,
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
              onChange: manager.onDockSettingsChange,
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
            devToolsOptions: state.visualDebugFlags,
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