import 'package:flutter/material.dart';
import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:stockholm/stockholm.dart';

import '../components/checkbox_list.dart';
import '../components/dropdown.dart';
import '../components/labeled_control.dart';
import '../components/numbered_slider.dart';
import '../components/text.dart';

import '../../../utils/translations.dart';
import '../../manager/controller_manager.dart';

const dividerHeight = 24.0;

class ControlPanel extends StatelessWidget {
  final ControllerManager manager;
  final double width;

  const ControlPanel({
    required this.manager,
    Key? key,
    this.width = 353,
  }) : super(key: key);
  static const controlWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    final _translations = Translations.of(context)!;
    var state = manager.state;
    var actions = manager.actions!;

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
              onChange: actions.onDeviceChanged,
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
              onChange: actions.onThemeChanged,
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
              onChange: actions.onLocaleChanged,
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
              onChanged: actions.onTextScaleFactorChanged,
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
              onChange: actions.onScaleChanged,
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
              onChange: actions.onDockSettingsChange,
              toStringFunction: (e) => _translations.text(e.name),
            ),
            controlWidth: controlWidth,
          ),
          const ControlPanelDivider(),
          LabeledControl(
            label: 'controls.visual_debugging',
            control: CheckboxList(
              visualDebugFlags: state.visualDebugFlags,
              onFlagToggled: actions.onVisualDebugFlagToggledByUi,
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
                  onPressed: actions.launchDevTools,
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
