import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/translations.dart';

class TextHeadline1 extends TextWidget {
  const TextHeadline1(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge;
}

class TextHeadline2 extends TextWidget {
  const TextHeadline2(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium;
}

class TextHeadline3 extends TextWidget {
  const TextHeadline3(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall;
}

class TextHeadline4 extends TextWidget {
  const TextHeadline4(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium;
}

class TextHeadline5 extends TextWidget {
  const TextHeadline5(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall;
}

class TextHeadline6 extends TextWidget {
  const TextHeadline6(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge;
}

class TextSubtitle1 extends TextWidget {
  const TextSubtitle1(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium;
}

class TextSubtitle2 extends TextWidget {
  const TextSubtitle2(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall;
}

class TextBody1 extends TextWidget {
  const TextBody1(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge;
}

class TextBody2 extends TextWidget {
  const TextBody2(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium;
}

class TextCaption extends TextWidget {
  const TextCaption(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;
}

class TextOverline extends TextWidget {
  const TextOverline(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall;
}

class ButtonText extends TextWidget {
  const ButtonText(
    super.text, {
    super.key,
    super.args,
    super.shouldTranslate,
    super.shouldBeCopyable,
    super.copyConfirmationText,
    super.textAlign = null,
    super.overflow,
    super.maxLines,
    super.maxFontSize,
    super.minFontSize,
    super.shouldAutoResize,
    super.shouldUpperCase,
    super.fontSizeMultiplier,
    super.styles,
  });

  @override
  TextStyle? style(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;
}

abstract class TextWidget extends StatelessWidget {
  final String text;
  final List<String>? args;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? maxFontSize, minFontSize;
  final bool? shouldUpperCase,
      shouldAutoResize,
      shouldTranslate,
      shouldBeCopyable;
  final String? copyConfirmationText;
  final TextStyle? styles;
  final double? fontSizeMultiplier;

  TextStyle? style(BuildContext context);

  const TextWidget(
    this.text, {
    this.shouldTranslate,
    this.shouldAutoResize,
    this.shouldBeCopyable,
    this.fontSizeMultiplier,
    this.copyConfirmationText,
    this.minFontSize,
    this.maxFontSize,
    this.styles,
    this.overflow,
    this.maxLines,
    this.args,
    this.textAlign = TextAlign.start,
    this.shouldUpperCase,
    super.key,
  });

  bool get _shouldTranslate => shouldTranslate ?? false;

  bool get _shouldUpperCase => shouldUpperCase ?? false;

  bool get _shouldBeCopyable => shouldBeCopyable ?? false;

  @override
  Widget build(BuildContext context) {
    final translations = Translations.of(context);
    var translatedText = _shouldTranslate && translations != null
        ? translations.textWithArgs(text, args ?? [])
        : text;
    var formattedText =
        _shouldUpperCase ? translatedText.toUpperCase() : translatedText;

    var styles_ =
        styles == null ? style(context) : style(context)?.merge(styles);

    var textWidget = Text(
      formattedText,
      overflow: overflow,
      style: styles_,
      textAlign: textAlign,
      maxLines: maxLines,
    );

    if (_shouldBeCopyable) {
      return GestureDetector(
        child: textWidget,
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: formattedText));
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(copyConfirmationText ?? 'Text Copied!')));
        },
      );
    }

    return textWidget;
  }
}
