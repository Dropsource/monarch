import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.canReset = false,
    this.hint,
    this.onReset,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool canReset;
  final String? hint;
  final Function? onReset;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyText2,
      placeholderStyle: Theme.of(context).textTheme.bodyText2,
      onChanged: (value) => onChanged?.call(value),
      placeholder: hint,
    );
  }
}
