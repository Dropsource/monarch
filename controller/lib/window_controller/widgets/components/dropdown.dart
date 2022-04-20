import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';

class DropDown<T> extends StatelessWidget{
  final List<T> values;
  final T currentValue;
  final Function(T?)? onChange;
  final String Function(T) toStringFunction;
  final double horizontalPadding;

  final Map<String, T> stringfiedValues;

  T get(String val) => stringfiedValues[val]!;

  DropDown({
    Key? key,
    required this.currentValue,
    required this.values,
    this.onChange,
    required this.toStringFunction,
    this.horizontalPadding = 16,
  })  : stringfiedValues = {for (var e in values) toStringFunction(e): e}, super(key:key);

  @override
  Widget build(BuildContext context) =>
        DropdownButton<String> (
          key: key,
          value: toStringFunction(currentValue),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 8,
          isExpanded: true,
          underline: const SizedBox(),
          style: const TextStyle(color: Colors.white),
          onChanged: (string) => onChange?.call(stringfiedValues[string]!),
          items: values.map<DropdownMenuItem<String>>((T value) {
            final converted = toStringFunction(value);
            return DropdownMenuItem<String>(
              value: converted,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: TextBody1(converted, shouldTranslate: false),
              ),
            );
          }).toList(),
        );
}
