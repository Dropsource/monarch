import 'package:flutter/material.dart';

enum ButtonStyles { primary, secondary, disabled }

class Button extends StatelessWidget {
  final String text;
  final ButtonStyles style;

  const Button(this.text, this.style, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: () => {},
            style: TextButton.styleFrom(
                foregroundColor: getPrimaryColor(),
                backgroundColor: getBackgroundColor(),
                side: style == ButtonStyles.secondary
                    ? const BorderSide(width: 0, color: Colors.black87)
                    : null),
            child: Text(text)));
  }

  Color getPrimaryColor() {
    switch (style) {
      case ButtonStyles.primary:
        return Colors.white;
      case ButtonStyles.secondary:
        return Colors.black87;
      case ButtonStyles.disabled:
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  Color getBackgroundColor() {
    switch (style) {
      case ButtonStyles.primary:
        return Colors.green;
      case ButtonStyles.secondary:
        return Colors.white;
      case ButtonStyles.disabled:
        return const Color(0xFFE0E0E0);
      default:
        return Colors.green;
    }
  }
}
