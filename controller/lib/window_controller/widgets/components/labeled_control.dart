import 'package:flutter/material.dart';

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
    this.controlWidth = 380,
    this.labelControlSpacing = 8,
    this.verticalPadding = 4,
    this.horizontalPadding = 8,
  }) : super(
          key: key,
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  label,
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
