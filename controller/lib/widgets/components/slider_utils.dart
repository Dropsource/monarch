import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomDividerShape extends SfDividerShape {
  /// Paints the dividers based on the values passed to it.
  @override
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    late bool isActive;
    final bool isVertical = _isVertical(parentBox);

    if (!isVertical) {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding active range.
      if (startThumbCenter != null) {
        if (!_isInverted(parentBox)) {
          isActive = center.dx >= startThumbCenter.dx &&
              center.dx <= endThumbCenter!.dx;
        } else {
          isActive = center.dx >= endThumbCenter!.dx &&
              center.dx <= startThumbCenter.dx;
        }
      } else {
        if (!_isInverted(parentBox)) {
          isActive = center.dx <= thumbCenter!.dx;
        } else {
          isActive = center.dx >= thumbCenter!.dx;
        }
      }
    } else {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding active range.
      if (startThumbCenter != null) {
        if (!_isInverted(parentBox)) {
          isActive = center.dy <= startThumbCenter.dy &&
              center.dy >= endThumbCenter!.dy;
        } else {
          isActive = center.dy >= startThumbCenter.dy &&
              center.dy <= endThumbCenter!.dy;
        }
      } else {
        if (!_isInverted(parentBox)) {
          isActive = center.dy >= thumbCenter!.dy;
        } else {
          isActive = center.dy <= thumbCenter!.dy;
        }
      }
    }

    if (paint == null) {
      paint = Paint();
      final Color begin = isActive
          ? themeData.disabledActiveDividerColor!
          : themeData.disabledInactiveDividerColor!;
      final Color end = isActive
          ? themeData.activeDividerColor!
          : themeData.inactiveDividerColor!;

      paint.color =
          ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
    }

    final double dividerRadius =
        getPreferredSize(themeData, isActive: isActive).width / 2;
    context.canvas.drawLine(Offset(center.dx, center.dy - dividerRadius),
        Offset(center.dx, center.dy + dividerRadius), paint);
  }

//no vertical slider support for this shape
  bool _isVertical(parentBox) {
    return false;
  }

//no support for inverted shape
  bool _isInverted(partentBox) {
    return false;
  }
}
