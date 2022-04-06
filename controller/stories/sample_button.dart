import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ButtonStyles { primary, secondary, disabled }

class Button extends StatelessWidget {
  final String text;
  final ButtonStyles style;

  Button(this.text, this.style);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: () => null,
            style: TextButton.styleFrom(
                primary: getPrimaryColor(),
                backgroundColor: getBackgroundColor(),
                side: style == ButtonStyles.secondary
                    ? BorderSide(width: 0, color: Colors.black87)
                    : null),
            child: Text(this.text)));
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
        return Color(0xFFE0E0E0);
      default:
        return Colors.green;
    }
  }
}
