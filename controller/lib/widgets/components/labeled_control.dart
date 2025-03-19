import 'package:flutter/material.dart';
import 'package:monarch_controller/widgets/components/text.dart';

class LabeledControl extends Padding {
  final String label;
  final Widget control;
  final double controlWidth;
  final double labelControlSpacing;
  final double verticalPadding;
  final double horizontalPadding;
  final bool shouldTranslate;

  LabeledControl({
    super.key,
    required this.label,
    required this.control,
    this.controlWidth = 340,
    this.labelControlSpacing = 10,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.shouldTranslate = true,
  }) : super(
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: TextBody1(
                      label,
                      shouldTranslate: shouldTranslate,
                      textAlign: TextAlign.end,
                    )),
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
