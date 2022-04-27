import 'package:flutter/material.dart';
import '../stockholm/stockholm.dart';

const _minMenuEdgePadding = 8.0;

Rect getGlobalBoundsForContext(BuildContext context) {
  var renderBox = context.findRenderObject() as RenderBox;
  var overlay =
      Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

  return Rect.fromPoints(
    renderBox.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    ),
    renderBox.localToGlobal(
      renderBox.size.bottomRight(Offset.zero),
      ancestor: overlay,
    ),
  );
}

Future showStockholmMenu({
  required BuildContext context,
  required Offset preferredAnchorPoint,
  required StockholmMenu menu,
  Alignment alignment = Alignment.topLeft,
  String? semanticLabel,
  bool useRootNavigator = false,
}) {
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_PopupMenuRoute(
    preferredAnchorPoint: preferredAnchorPoint,
    alignment: alignment,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    capturedThemes:
        InheritedTheme.capture(from: context, to: navigator.context),
    menu: menu,
  ));
}

class _PopupMenuRoute extends PopupRoute {
  _PopupMenuRoute({
    required this.preferredAnchorPoint,
    required this.alignment,
    required this.barrierLabel,
    this.semanticLabel,
    required this.capturedThemes,
    required this.menu,
  });

  final Offset preferredAnchorPoint;
  final String? semanticLabel;
  final CapturedThemes capturedThemes;
  final StockholmMenu menu;
  final Alignment alignment;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              preferredAnchorPoint,
              alignment,
              Directionality.of(context),
              mediaQuery.padding,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.preferredAnchorPoint,
    this.alignment,
    this.textDirection,
    this.padding,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  // final RelativeRect position;
  final Offset preferredAnchorPoint;

  final Alignment alignment;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(8.0) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Take alignment into account.
    var x = preferredAnchorPoint.dx - (alignment.x + 1) / 2 * childSize.width;
    var y = preferredAnchorPoint.dy - (alignment.y + 1) / 2 * childSize.height;

    // Push the menu inside the bounds if necessary.
    if (x < _minMenuEdgePadding) {
      x = _minMenuEdgePadding;
    }
    if (y < _minMenuEdgePadding) {
      y = _minMenuEdgePadding;
    }
    if (x > size.width - _minMenuEdgePadding - childSize.width) {
      x = size.width - _minMenuEdgePadding - childSize.width;
    }
    if (y > size.height - _minMenuEdgePadding - childSize.height) {
      y = size.height - _minMenuEdgePadding - childSize.height;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    // assert(itemSizes.length == oldDelegate.itemSizes.length);

    return preferredAnchorPoint != oldDelegate.preferredAnchorPoint ||
        textDirection != oldDelegate.textDirection ||
        padding != oldDelegate.padding;
  }
}
