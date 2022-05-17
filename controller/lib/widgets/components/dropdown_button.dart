import 'package:flutter/material.dart';
import 'package:stockholm/stockholm.dart';

import 'button.dart' as local;

///code credits to stockholm widget library
///https://github.com/serverpod/stockholm
///
class StockholmDropdownButton<T> extends StatefulWidget {
  const StockholmDropdownButton({
    required this.items,
    required this.onChanged,
    required this.value,
    this.icon = const Icon(
      Icons.expand_more,
      size: 10,
    ),
    this.width,
    Key? key,
  }) : super(key: key);

  final List<StockholmDropdownItem<T>> items;
  final ValueChanged<T> onChanged;
  final T value;
  final Widget? icon;
  final double? width;

  @override
  _StockholmDropdownButtonState createState() =>
      _StockholmDropdownButtonState<T>();
}

class _StockholmDropdownButtonState<T>
    extends State<StockholmDropdownButton<T>> {
  @override
  Widget build(BuildContext context) {
    var items = widget.items
        .map(
          (e) => StockholmMenuItem(
            onSelected: () {
              widget.onChanged(e.value);
            },
            child: e,
          ),
        )
        .toList();

    var currentIndex =
        widget.items.indexWhere((element) => element.value == widget.value);
    Widget currentItem = widget.items[currentIndex];

    var offsetY = 0.0;
    for (var i = 0; i < currentIndex; i += 1) {
      offsetY += items[i].height;
    }

    if (widget.width != null) {
      currentItem = Expanded(
        child: currentItem,
      );
    }

    return SizedBox(
      width: widget.width,
      child: local.StockholmButton(
        padding: EdgeInsets.only(
          left: 12,
          right: widget.icon == null ? 8 : 4,
          top: 0,
          bottom: 0,
        ),
        onPressed: () {
          var bounds = getGlobalBoundsForContext(context);
          showStockholmMenu(
            context: context,
            preferredAnchorPoint: Offset(
              bounds.left - 9,
              bounds.top - offsetY - 3,
            ),
            menu: StockholmMenu(
              items: items,
              width: widget.width,
            ),
          );
        },
        child: Row(
          children: [
            currentItem,
            if (widget.icon != null)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: widget.icon,
              ),
          ],
        ),
      ),
    );
  }
}

class StockholmDropdownItem<T> extends StatelessWidget {
  const StockholmDropdownItem({
    required this.value,
    required this.child,
    Key? key,
  }) : super(key: key);

  final T value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
