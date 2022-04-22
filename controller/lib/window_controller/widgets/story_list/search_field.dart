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
      // decoration: InputDecoration(
      //   hintText: hint,
      //   contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      //   suffixIcon: canReset
      //       ? IconButton(
      //           icon: const Icon(Icons.clear_rounded),
      //           hoverColor: Colors.transparent,
      //           splashRadius: 15,
      //           onPressed: () => onReset?.call(),
      //         )
      //       : null,
      // ),
    );
  }
}
