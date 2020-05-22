import 'package:flutter/material.dart';

import '../../storybook_data.dart';
import '../../logical_resolution.dart';
import '../color_palette.dart';

class StoryResolutionView extends StatelessWidget {
  final StoryFunction storyFunction;
  final LogicalResolution resolution;

  StoryResolutionView({this.storyFunction, this.resolution});

  @override
  Widget build(BuildContext context) {
    // return storyFunction();
    return Container(
        width: resolution.width,
        height: resolution.height,
        decoration: BoxDecoration(
          boxShadow: [
            CustomBoxShadow(
                color: ColorPalette.slateGrey,
                offset: Offset(0, 0),
                blurRadius: 5.0,
                blurStyle: BlurStyle.outer)
          ],
        ),
        child: ClipRect(child: storyFunction()));
  }
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
