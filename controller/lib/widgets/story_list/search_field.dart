import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.canReset = false,
    this.hint,
    this.onReset,
    this.focusNode,
  });

  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool canReset;
  final String? hint;
  final Function? onReset;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      autofocus: true,
      style: Theme.of(context).textTheme.bodyMedium,
      placeholderStyle: Theme.of(context).textTheme.bodyMedium,
      onChanged: (value) => onChanged?.call(value),
      placeholder: hint,
      focusNode: focusNode,
    );
  }
}
