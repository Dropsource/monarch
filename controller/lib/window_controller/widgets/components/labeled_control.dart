import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';

class LabeledControl extends Padding {
  final String label;
  final Widget control;
  final double controlWidth;
  final double labelControlSpacing;
  final double verticalPadding;
  final double horizontalPadding;

  LabeledControl({
    Key? key,
    required this.label,
    required this.control,
    this.controlWidth = 340,
    this.labelControlSpacing = 16,
    this.verticalPadding = 0,
    this.horizontalPadding = 16,
  }) : super(
          key: key,
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: TextBody1(
                  label,
                  shouldTranslate: true,
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: labelControlSpacing,
              ),
              SizedBox(
                width: controlWidth,
                child: control,
              )
            ],
          ),
        );
}
