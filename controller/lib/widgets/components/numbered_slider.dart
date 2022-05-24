import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monarch_controller/widgets/components/slider_utils.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../default_theme.dart';

class NumberedSlider extends StatefulWidget {
  final double initialValue;
  final Function(double) onChanged;

  const NumberedSlider({
    Key? key,
    this.initialValue = 1.0,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<NumberedSlider> createState() => _NumberedSlideState();
}

class _NumberedSlideState extends State<NumberedSlider> {
  static const intervalsToShowLabel = ['0.7', '1.0', '1.5', '2.0'];
  static const minValue = 0.7;
  static const maxValue = 2.01;
  static const stepValue = 0.1;

  final _focusNode = FocusNode(skipTraversal: true);

  bool _focused = false;
  double value = 1.0;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onFocusChange: (focused) => setState(() => _focused = focused),
      onKey: (node, event) {
        if (event is! RawKeyDownEvent) {
          return KeyEventResult.ignored;
        }

        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          onArrowLeft();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          onArrowRight();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: SfSliderTheme(
        data: SfSliderThemeData(
          activeTrackHeight: 2,
          inactiveTrackHeight: 2,
          thumbRadius: 7,
          activeTrackColor: sliderTrackColor,
          inactiveTrackColor: sliderTrackColor,
          thumbColor: sliderThumbColor,
          activeTickColor: sliderDividerColor,
          inactiveTickColor: sliderDividerColor,
          activeDividerColor: sliderDividerColor,
          inactiveDividerColor: sliderDividerColor,
          activeDividerRadius: 4,
          inactiveDividerRadius: 4,
          overlayRadius: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: _focused ? Colors.red : Colors.blue)),
          child: SfSlider(
            value: value,
            min: minValue,
            max: maxValue,
            stepSize: stepValue,
            interval: stepValue,
            showDividers: true,
            dividerShape: CustomDividerShape(),
            //minorTicksPerInterval: 3,
            labelFormatterCallback: (value, v) {
              final val = value.toStringAsFixed(1);
              return intervalsToShowLabel.contains(val) ? val : '';
            },
            showLabels: true,
            showTicks: false,
            enableTooltip: false,
            onChanged: (newValue) {
              setState(() {
                value = newValue;
                widget.onChanged(newValue);

                if (!_focusNode.hasFocus) {
                  FocusScope.of(context).requestFocus(_focusNode);
                }
              });
            },
            // activeColor: Colors.white,
            // inactiveColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void onArrowLeft() {
    if (value - stepValue >= minValue) {
      setState(() => value -= stepValue);
    }
  }

  void onArrowRight() {
    if (value + stepValue < maxValue) {
      setState(() => value += stepValue);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
