import 'package:flutter/material.dart';

List<BoxShadow> stockholmBoxShadow(BuildContext context) {
  return [
    BoxShadow(
      offset: const Offset(0.0, 1.0),
      blurRadius: 0.5,
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black12
          : Colors.black54,
    ),
  ];
}
