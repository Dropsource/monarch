import 'package:flutter/material.dart';

class DropDown<T> extends DropdownButton<String> {
  final List<T> values;
  final T currentValue;
  final Function(T?)? onChange;
  final String Function(T) toStringFunction;

  final Map<String, T> stringfiedValues;

  T get(String val) => stringfiedValues[val]!;

  DropDown({
    Key? key,
    required this.currentValue,
    required this.values,
    this.onChange,
    required this.toStringFunction,
  })  : stringfiedValues = {for (var e in values) toStringFunction(e): e},
        super(
          key: key,
          value: toStringFunction(currentValue),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          isExpanded: true,
          underline: const SizedBox(),
          style: const TextStyle(color: Colors.white),
          onChanged: (string) {},
          items: values.map<DropdownMenuItem<String>>((T value) {
            final converted = toStringFunction(value);
            return DropdownMenuItem<String>(
              value: converted,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(converted),
              ),
            );
          }).toList(),
        );
}
