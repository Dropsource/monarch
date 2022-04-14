// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// Examples can assume:
// void setState(VoidCallback fn) { }

/// A [ListTile] with a [Checkbox]. In other words, a checkbox with a label.
///
/// The entire list tile is interactive: tapping anywhere in the tile toggles
/// the checkbox.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=RkSqPAn9szs}
///
/// The [value], [onChanged], [activeColor] and [checkColor] properties of this widget are
/// identical to the similarly-named properties on the [Checkbox] widget.
///
/// The [title], [subtitle], [isThreeLine], [dense], and [contentPadding] properties are like
/// those of the same name on [ListTile].
///
/// The [selected] property on this widget is similar to the [ListTile.selected]
/// property. This tile's [activeColor] is used for the selected item's text color, or
/// the theme's [ThemeData.toggleableActiveColor] if [activeColor] is null.
///
/// This widget does not coordinate the [selected] state and the [value] state; to have the list tile
/// appear selected when the checkbox is checked, pass the same value to both.
///
/// The checkbox is shown on the right by default in left-to-right languages
/// (i.e. the trailing edge). This can be changed using [controlAffinity]. The
/// [secondary] widget is placed on the opposite side. This maps to the
/// [ListTile.leading] and [ListTile.trailing] properties of [ListTile].
///
/// To show the [CheckboxListTile] as disabled, pass null as the [onChanged]
/// callback.
///
/// {@tool dartpad}
/// ![CheckboxListTile sample](https://flutter.github.io/assets-for-api-docs/assets/material/checkbox_list_tile.png)
///
/// This widget shows a checkbox that, when checked, slows down all animations
/// (including the animation of the checkbox itself getting checked!).
///
/// This sample requires that you also import 'package:flutter/scheduler.dart',
/// so that you can reference [timeDilation].
///
/// ** See code in examples/api/lib/material/checkbox_list_tile/checkbox_list_tile.0.dart **
/// {@end-tool}
///
/// ## Semantics in CheckboxListTile
///
/// Since the entirety of the CheckboxListTile is interactive, it should represent
/// itself as a single interactive entity.
///
/// To do so, a CheckboxListTile widget wraps its children with a [MergeSemantics]
/// widget. [MergeSemantics] will attempt to merge its descendant [Semantics]
/// nodes into one node in the semantics tree. Therefore, CheckboxListTile will
/// throw an error if any of its children requires its own [Semantics] node.
///
/// For example, you cannot nest a [RichText] widget as a descendant of
/// CheckboxListTile. [RichText] has an embedded gesture recognizer that
/// requires its own [Semantics] node, which directly conflicts with
/// CheckboxListTile's desire to merge all its descendants' semantic nodes
/// into one. Therefore, it may be necessary to create a custom radio tile
/// widget to accommodate similar use cases.
///
/// {@tool dartpad}
/// ![Checkbox list tile semantics sample](https://flutter.github.io/assets-for-api-docs/assets/material/checkbox_list_tile_semantics.png)
///
/// Here is an example of a custom labeled checkbox widget, called
/// LinkedLabelCheckbox, that includes an interactive [RichText] widget that
/// handles tap gestures.
///
/// ** See code in examples/api/lib/material/checkbox_list_tile/checkbox_list_tile.1.dart **
/// {@end-tool}
///
/// ## CheckboxListTile isn't exactly what I want
///
/// If the way CheckboxListTile pads and positions its elements isn't quite
/// what you're looking for, you can create custom labeled checkbox widgets by
/// combining [Checkbox] with other widgets, such as [Text], [Padding] and
/// [InkWell].
///
/// {@tool dartpad}
/// ![Custom checkbox list tile sample](https://flutter.github.io/assets-for-api-docs/assets/material/checkbox_list_tile_custom.png)
///
/// Here is an example of a custom LabeledCheckbox widget, but you can easily
/// make your own configurable widget.
///
/// ** See code in examples/api/lib/material/checkbox_list_tile/checkbox_list_tile.2.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ListTileTheme], which can be used to affect the style of list tiles,
///    including checkbox list tiles.
///  * [RadioListTile], a similar widget for radio buttons.
///  * [SwitchListTile], a similar widget for switches.
///  * [ListTile] and [Checkbox], the widgets from which this widget is made.
class CustomCheckboxListTile extends StatelessWidget {
  /// Creates a combination of a list tile and a checkbox.
  ///
  /// The checkbox tile itself does not maintain any state. Instead, when the
  /// state of the checkbox changes, the widget calls the [onChanged] callback.
  /// Most widgets that use a checkbox will listen for the [onChanged] callback
  /// and rebuild the checkbox tile with a new [value] to update the visual
  /// appearance of the checkbox.
  ///
  /// The following arguments are required:
  ///
  /// * [value], which determines whether the checkbox is checked. The [value]
  ///   can only be null if [tristate] is true.
  /// * [onChanged], which is called when the value of the checkbox should
  ///   change. It can be set to null to disable the checkbox.
  ///
  /// The value of [tristate] must not be null.
  const CustomCheckboxListTile({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.tristate = false,
    this.shape,
    this.selectedTileColor,
    this.side,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.minLeadingWidth,
  }) : assert(tristate != null),
        assert(tristate || value != null),
        assert(isThreeLine != null),
        assert(!isThreeLine || subtitle != null),
        assert(selected != null),
        assert(controlAffinity != null),
        assert(autofocus != null),
        super(key: key);

  /// Whether this checkbox is checked.
  final bool? value;

  final double? minLeadingWidth;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox tile with the
  /// new value.
  ///
  /// If null, the checkbox will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// CheckboxListTile(
  ///   value: _throwShotAway,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue;
  ///     });
  ///   },
  ///   title: Text('Throw away your shot'),
  /// )
  /// ```
  final ValueChanged<bool?>? onChanged;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to accent color of the current [Theme].
  final Color? activeColor;

  /// The color to use for the check icon when this checkbox is checked.
  ///
  /// Defaults to Color(0xFFFFFFFF).
  final Color? checkColor;

  /// {@macro flutter.material.ListTile.tileColor}
  final Color? tileColor;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// A widget to display on the opposite side of the tile from the checkbox.
  ///
  /// Typically an [Icon] widget.
  final Widget? secondary;

  /// Whether this list tile is intended to display three lines of text.
  ///
  /// If false, the list tile is treated as having one line if the subtitle is
  /// null and treated as having two lines if the subtitle is non-null.
  final bool isThreeLine;

  /// Whether this list tile is part of a vertically dense list.
  ///
  /// If this property is null then its value is based on [ListTileThemeData.dense].
  final bool? dense;

  /// Whether to render icons and text in the [activeColor].
  ///
  /// No effort is made to automatically coordinate the [selected] state and the
  /// [value] state. To have the list tile appear selected when the checkbox is
  /// checked, pass the same value to both.
  ///
  /// Normally, this property is left to its default value, false.
  final bool selected;

  /// Where to place the control relative to the text.
  final ListTileControlAffinity controlAffinity;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Defines insets surrounding the tile's contents.
  ///
  /// This value will surround the [Checkbox], [title], [subtitle], and [secondary]
  /// widgets in [CheckboxListTile].
  ///
  /// When the value is null, the `contentPadding` is `EdgeInsets.symmetric(horizontal: 16.0)`.
  final EdgeInsetsGeometry? contentPadding;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// Checkbox displays a dash when its value is null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  final bool tristate;

  /// {@macro flutter.material.ListTile.shape}
  final ShapeBorder? shape;

  /// If non-null, defines the background color when [CheckboxListTile.selected] is true.
  final Color? selectedTileColor;

  /// {@macro flutter.material.checkbox.side}
  ///
  /// The given value is passed directly to [Checkbox.side].
  ///
  /// If this property is null, then [CheckboxThemeData.side] of
  /// [ThemeData.checkboxTheme] is used. If that is also null, then the side
  /// will be width 2.
  final BorderSide? side;

  /// Defines how compact the list tile's layout will be.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  final VisualDensity? visualDensity;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.material.ListTile.enableFeedback}
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  void _handleValueChange() {
    assert(onChanged != null);
    switch (value) {
      case false:
        onChanged!(true);
        break;
      case true:
        onChanged!(tristate ? null : false);
        break;
      case null:
        onChanged!(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget control = Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      checkColor: checkColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      autofocus: autofocus,
      tristate: tristate,
      side: side,
    );
    Widget? leading, trailing;
    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = control;
        trailing = secondary;
        break;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        leading = secondary;
        trailing = control;
        break;
    }
    return MergeSemantics(
      child: ListTileTheme.merge(
        selectedColor: activeColor ?? Theme.of(context).toggleableActiveColor,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          isThreeLine: isThreeLine,
          minLeadingWidth: minLeadingWidth,
          dense: dense,
          enabled: onChanged != null,
          onTap: onChanged != null ? _handleValueChange : null,
          selected: selected,
          autofocus: autofocus,
          contentPadding: contentPadding,
          shape: shape,
          selectedTileColor: selectedTileColor,
          tileColor: tileColor,
          visualDensity: visualDensity,
          focusNode: focusNode,
          enableFeedback: enableFeedback,
          horizontalTitleGap: 4,
        ),
      ),
    );
  }
}
