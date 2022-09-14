import 'package:flutter/material.dart';
import 'package:stockholm/stockholm.dart';

const _menuPadding = 4.0;

/// StockholmMenu with a ListView child instead of an IntrinsicWidth child.
class ScrollableStockholmMenu extends StockholmMenu {
  const ScrollableStockholmMenu(
      {required List<StockholmMenuEntity> items, double? width, Key? key})
      : super(items: items, width: width, key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).popupMenuTheme.color,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 4),
              )
            ],
            border: Border.all(color: Theme.of(context).dividerColor)),
        padding: const EdgeInsets.all(_menuPadding),
        child: SizedBox(
          width: width,
          child: ListView(children: items, shrinkWrap: true,)
        ));
  }
}
