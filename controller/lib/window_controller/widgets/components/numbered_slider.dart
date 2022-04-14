import 'package:flutter/material.dart';

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

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: 0.7,
      max: 2.0,
      thumbColor: Colors.white,
      divisions: 13,
      label: value.toStringAsFixed(1),
      onChanged: (double newValue) {
        setState(() {
          value = newValue;
          widget.onChanged(newValue);
        });
      },
      activeColor: Colors.white,
      inactiveColor: Colors.white,
    );
  }
}
