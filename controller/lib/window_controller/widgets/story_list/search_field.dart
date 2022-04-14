import 'package:flutter/material.dart';

class SearchField extends Stack {
  SearchField({
    Key? key,
    required TextEditingController controller,
    Function(String)? onChanged,
    bool canReset = false,
    String? hint,
    Function? onReset,
  }) : super(key: key, children: [
          TextFormField(
            controller: controller,

            onChanged: (value) => onChanged?.call(value),
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              suffixIcon: canReset
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      hoverColor: Colors.transparent,
                      splashRadius: 15,
                      onPressed: () => onReset?.call(),
                    )
                  : null,
            ),
          )
        ]);
}
