import 'package:flutter/material.dart';
import 'package:test_localizations/localizations.dart';
import 'sample_button.dart';

String translate(BuildContext context, String key) =>
    SampleLocalizations.of(context)!.text(key);

Widget primary() => Builder(
    builder: (context) =>
        Button(translate(context, 'Button'), ButtonStyles.primary));

Widget secondary() => Builder(
    builder: (context) =>
        Button(translate(context, 'Button'), ButtonStyles.secondary));

Widget disabled() => Builder(
    builder: (context) =>
        Button(translate(context, 'Button'), ButtonStyles.disabled));
