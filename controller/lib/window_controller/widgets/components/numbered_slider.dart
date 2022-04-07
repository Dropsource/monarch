import 'package:flutter/material.dart';

class NumberedSlider extends StatefulWidget {
  const NumberedSlider({Key? key}) : super(key: key);

  @override
  State<NumberedSlider> createState() => _NumberedSlideState();
}

class _NumberedSlideState extends State<NumberedSlider> {
  double value = 1.0;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: 0.7,
      max: 2.0,
      thumbColor: Colors.white,
      divisions: 13,
      label: value.toStringAsFixed(1),
      onChangeStart: (double value) {
        print('Start value is ' + value.toString());
      },
      onChangeEnd: (double value) {
        print('Finish value is ' + value.toString());
      },
      onChanged: (double newValue) {
        setState(() {
          value = newValue;
        });
      },
      activeColor: Colors.white,
      inactiveColor: Colors.white,
    );
  }
}
