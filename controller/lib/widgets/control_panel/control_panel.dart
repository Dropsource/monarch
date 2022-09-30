import 'package:flutter/material.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

import 'package:monarch_controller/data/dock_definition.dart';
import 'package:monarch_controller/widgets/components/checkbox_list.dart';
import 'package:monarch_controller/widgets/components/dropdown.dart';
import 'package:monarch_controller/widgets/components/labeled_control.dart';
import 'package:monarch_controller/widgets/components/numbered_slider.dart';
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/manager/controller_state.dart';
import 'package:stockholm/stockholm.dart';

import '../../../utils/translations.dart';
import '../components/text.dart';

const dividerHeight = 24.0;

class ControlPanel extends StatelessWidget {
  final ControllerState state;
  final double width;
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
              skipTraversal: true,
            ),
            controlWidth: controlWidth,
          ),
          const SizedBox(
            height: 8,
          ),
          LabeledControl(
            label: 'controls.theme',
            control: DropDown<MetaThemeDefinition>(
              currentValue: state.currentTheme,
              values: state.allThemes,
              skipTraversal: true,
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
              skipTraversal: true,
              toStringFunction: (e) => e.toString(),
              onChange: manager.onLocaleChanged,
            ),
            controlWidth: controlWidth,
          ),
          const SizedBox(
            height: 15,
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
          const ControlPanelDivider(),
          LabeledControl(
            label: 'controls.scale',
            control: DropDown<StoryScaleDefinition>(
              currentValue: state.currentScale,
              values: state.scaleList.toList(),
              skipTraversal: true,
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
              skipTraversal: true,
              onChange: manager.onDockSettingsChange,
              toStringFunction: (e) => _translations.text(e.name),
            ),
            controlWidth: controlWidth,
          ),
          const ControlPanelDivider(),
          LabeledControl(
            label: 'controls.visual_debugging',
            control: CheckboxList(
              visualDebugFlags: state.visualDebugFlags,
              onFlagToggled: manager.onVisualDebugFlagToggledByUi,
            ),
            controlWidth: controlWidth,
          ),
          const ControlPanelDivider(),
          Row(
            children: [
              const SizedBox(
                width: 87,
              ),
              SizedBox(
                width: 140,
                child: StockholmButton(
                  onPressed: manager.launchDevTools,
                  child: const TextBody1('dev_tools.launch',
                      shouldTranslate: true),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ControlPanelDivider extends StatelessWidget {
  const ControlPanelDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 0.0,
      height: dividerHeight,
      color: Colors.white.withAlpha(100),
    );
  }
}
