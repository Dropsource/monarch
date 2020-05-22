import 'package:flutter/material.dart';

import '../color_palette.dart';

enum RulerDirection { horizontal, vertical }

class Ruler extends StatelessWidget {
  final RulerDirection direction;
  final double start;
  final double end;
  final double segmentLength;

  Ruler({this.direction, this.start, this.end, this.segmentLength});

  @override
  Widget build(BuildContext context) {
    final List<String> labels = [];
    for (double i = start; i < end; i = i + segmentLength) {
      labels.add('${i.toInt()}');
    }

    final segments = labels
        .map((l) => RulerSegment(label: l, direction: direction, longSideLength: segmentLength))
        .toList();

    if (direction == RulerDirection.horizontal) {
      return Row(children: segments);
    } else {
      return Column(children: segments);
    }
  }
}

class RulerSegment extends StatelessWidget {
  final String label;
  final RulerDirection direction;
  final double longSideLength;

  static const double shortSideLength = 24;

  static const double shortLineLength = 8; // shortSideLength / 3

  RulerSegment({this.label, this.direction, this.longSideLength = 100});

  @override
  Widget build(BuildContext context) {
    final width = direction == RulerDirection.horizontal
        ? longSideLength
        : shortSideLength;
    final height = direction == RulerDirection.horizontal
        ? shortSideLength
        : longSideLength;
    return CustomPaint(
        size: Size(width, height),
        painter: RulerSegmentPainter(
            label: label,
            direction: direction,
            shortLineLength: shortLineLength));
  }
}

/// Draws ruler lines in a segment of 100 logical pixels.
/// There will be 10 lines per 100 logical pixels. The first
/// line will be a tall line, the other nine will be short lines.
class RulerSegmentPainter extends CustomPainter {
  final String label;
  final RulerDirection direction;
  final double shortLineLength;

  RulerSegmentPainter({this.label, this.direction, this.shortLineLength});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorPalette.slateGrey
      ..strokeWidth = 0;

    final tallLineLength = shortLineLength * 3;
    final tallLineStart = Offset(0, 0);
    final tallLineEnd = direction == RulerDirection.horizontal
        ? Offset(0, tallLineLength)
        : Offset(tallLineLength, 0);

    canvas.drawLine(tallLineStart, tallLineEnd, paint);

    final double numberOfShortLines = _computeShortLines(
        direction == RulerDirection.horizontal ? size.width : size.height);
    const double spaceBetweenLines = 10;
    for (var i = 1; i < numberOfShortLines + 1; i++) {
      final shortLineStart = direction == RulerDirection.horizontal
          ? Offset(spaceBetweenLines * i, shortLineLength * 2)
          : Offset(shortLineLength * 2, spaceBetweenLines * i);

      final shortLineEnd = direction == RulerDirection.horizontal
          ? Offset(spaceBetweenLines * i, shortLineLength * 3)
          : Offset(shortLineLength * 3, spaceBetweenLines * i);

      canvas.drawLine(shortLineStart, shortLineEnd, paint);
    }

    final baseLineStart = direction == RulerDirection.horizontal
        ? Offset(0, tallLineLength)
        : Offset(tallLineLength, 0);
    final baseLineEnd = Offset(size.width, size.height);

    canvas.drawLine(baseLineStart, baseLineEnd, paint);

    _paintText(canvas, size);
  }

  double _computeShortLines(double sideLength) => sideLength / 10 - 1;

  void _paintText(Canvas canvas, Size size) {
    final textStyle = TextStyle(
        color: ColorPalette.darkGrey,
        fontSize: label.length <= 3 ? 10 : 9,
        height: 1);
    final textSpan = TextSpan(
      text: label,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset =
        direction == RulerDirection.horizontal ? Offset(4, 2) : Offset(1, 1);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
