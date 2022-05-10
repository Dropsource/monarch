import 'package:flutter/material.dart';
///code credits to stockholm widget library
///https://github.com/serverpod/stockholm

class StockholmButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;
  final bool large;
  final bool important;
  final bool enabled;

  const StockholmButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 12,
    ),
    this.large = false,
    this.important = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color textColor;
    if (enabled && onPressed != null) {
      if (important) {
        textColor = theme.buttonTheme.colorScheme!.onPrimary;
      } else {
        textColor = theme.buttonTheme.colorScheme!.onSurface;
      }
    } else {
      textColor = theme.disabledColor;
    }

    return MaterialButton(
      // textTheme: textTheme,
      color: important
          ? theme.colorScheme.primary
          : theme.buttonTheme.colorScheme!.surface,
      hoverColor: Theme.of(context).hoverColor,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
      ),
      onPressed: enabled ? onPressed : null,
      child: Container(
        alignment: Alignment.center,
        height: large ? 32 : 24,
        padding: padding,
        child: DefaultTextStyle(
          style: large
              ? theme.textTheme.button!.copyWith(color: textColor)
              : theme.textTheme.bodyText2!.copyWith(color: textColor),
          child: child,
        ),
      ),
      elevation: 0,
      minWidth: 32,
      padding: EdgeInsets.zero,
      height: 26,
    );
  }
}
