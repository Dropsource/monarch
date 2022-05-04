import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';

import 'dropdown_button.dart';

class DropDown<T> extends StatelessWidget {
  final List<T> values;
  final T currentValue;
  final Function(T)? onChange;
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
  })  : stringfiedValues = {for (var e in values) toStringFunction(e): e},
        super(key: key);

  @override
  Widget build(BuildContext context) => StockholmDropdownButton<String>(
        key: key,
        value: toStringFunction(currentValue),
        icon: const Icon(Icons.arrow_drop_down, size: 18,),
        width: 240,
        onChanged: (string) => onChange?.call(stringfiedValues[string]!),
        items: values.map<StockholmDropdownItem<String>>((T value) {
          final converted = toStringFunction(value);
          return StockholmDropdownItem<String>(
            value: converted,
            child: TextBody1(converted, shouldTranslate: false),
          );
        }).toList(),
      );
}
