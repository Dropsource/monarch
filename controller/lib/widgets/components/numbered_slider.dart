import 'package:flutter/material.dart';
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
  double value = 1.0;
  static const intervalsToShowLabel = ['0.7', '1.0', '1.5', '2.0'];

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 2,
        inactiveTrackHeight: 2,
        thumbRadius: 7,
        activeTrackColor: sliderTrackColor,
        inactiveTrackColor: sliderTrackColor,
        thumbColor: sliderThumbColor,
        thumbStrokeColor: Colors.green,
        activeTickColor: sliderDividerColor,
        inactiveTickColor: sliderDividerColor,
        activeDividerColor: sliderDividerColor,
        inactiveDividerColor: sliderDividerColor,
        activeDividerRadius: 4,
        inactiveDividerRadius: 4,
        overlayRadius: 0,
      ),
      child: SfSlider(
        value: value,
        min: 0.7,
        max: 2.001,
        stepSize: 0.1,
        interval: 0.1,
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
          });
        },
        // activeColor: Colors.white,
        // inactiveColor: Colors.white,
      ),
    );
  }
}
