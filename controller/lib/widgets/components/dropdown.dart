import 'package:flutter/material.dart';
import 'package:monarch_controller/widgets/components/text.dart';

import 'dropdown_button.dart';

///code credits to stockholm widget library
///https://github.com/serverpod/stockholm

class DropDown<T> extends StatelessWidget {
  final List<T> values;
  final T currentValue;
  final Function(T)? onChange;
  final String Function(T) toStringFunction;
  final double horizontalPadding;

  final Map<String, T> stringfiedValues;
  final bool skipTraversal;

  T get(String val) => stringfiedValues[val]!;

  DropDown({
    super.key,
    required this.currentValue,
    required this.values,
    this.onChange,
    required this.toStringFunction,
    this.horizontalPadding = 16,
    this.skipTraversal = false,
  })  : stringfiedValues = {for (var e in values) toStringFunction(e): e};

  @override
  Widget build(BuildContext context) => StockholmDropdownButton<String>(
        key: key,
        skipTraversal: skipTraversal,
        value: toStringFunction(currentValue),
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 18,
        ),
        width: 240,
        onChanged: (string) => onChange?.call(stringfiedValues[string] as T),
        items: values.map<StockholmDropdownItem<String>>((T value) {
          final converted = toStringFunction(value);
          return StockholmDropdownItem<String>(
            value: converted,
            child: TextBody1(converted, shouldTranslate: false),
          );
        }).toList(),
      );
}
