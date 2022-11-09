import 'package:flutter/material.dart';

import '../../default_theme.dart';

class TextWithHighlight extends StatelessWidget {
  final String highlightedText;
  final String text;

  const TextWithHighlight(
      {Key? key, required this.text, this.highlightedText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(children: _buildHighlighters(context)));
  }

  List<TextSpan> _buildHighlighters(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final newTextStyle = textStyle!.copyWith(color: searchHighlightColor);

    List<TextSpan>? textSpans = [];

    var originalText = text;

    if (highlightedText.isEmpty) {
      textSpans.add(TextSpan(text: originalText, style: textStyle));
    } else {
      final highlighterTextSpans = [highlightedText]
          .map((highlightedText) {
            if (highlightedText.isEmpty) {
              return [const TextSpan(text: '')];
            } else {
              final splitTextSpans = <TextSpan>[];
              final index = originalText
                  .toLowerCase()
                  .indexOf(highlightedText.toLowerCase());
              if (index == -1) {
                return [const TextSpan(text: '')];
              }
              final splitTexts = [
                originalText.substring(0, index),
                originalText.substring(index + highlightedText.length),
              ];

              if (splitTexts.length > 1) {
                final highlight = originalText.substring(
                    index, index + highlightedText.length);

                splitTextSpans
                    .add(TextSpan(text: splitTexts.first, style: textStyle));
                splitTextSpans
                    .add(TextSpan(text: highlight, style: newTextStyle));
                splitTexts.removeAt(0);
              }

              originalText = splitTexts.last;

              return splitTextSpans;
            }
          })
          .toList()
          .expand((element) => element)
          .toList();

      highlighterTextSpans.add(TextSpan(text: originalText, style: textStyle));
      textSpans.addAll(highlighterTextSpans);
    }

    return textSpans;
  }
}
