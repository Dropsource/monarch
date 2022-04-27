import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StockholmTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final bool autofocus;

  const StockholmTextField({
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign,
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      style: Theme.of(context).textTheme.bodyText2,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textAlign: textAlign ?? TextAlign.start,
      autofocus: autofocus,
    );
  }
}
