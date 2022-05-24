///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/foundation.dart';

/// A controller for a tree state.
///
/// Allows to modify the state of the tree.
class TreeController {
  bool _allNodesExpanded;
  final Map<Key, bool> _expanded = <Key, bool>{};
  Key? selectedKey;

  TreeController({allNodesExpanded = true})
      : _allNodesExpanded = allNodesExpanded;

  bool get allNodesExpanded => _allNodesExpanded;

  bool isNodeSelected(Key key) => key == selectedKey;

  bool isNodeExpanded(Key key) => _expanded[key] ?? _allNodesExpanded;

  void toggleNodeExpanded(Key key) => _expanded[key] = !isNodeExpanded(key);

  bool hasFocus = false;

  void expandAll() {
    _allNodesExpanded = true;
    _expanded.clear();
  }

  void collapseAll() {
    _allNodesExpanded = false;
    _expanded.clear();
  }

  void expandNode(Key key) {
    _expanded[key] = true;
  }

  void collapseNode(Key key) {
    _expanded[key] = false;
  }

  void selectKey(Key key) {
    selectedKey = key;
  }

  void onKeyLeft() {}

  void onKeyUp() {}

  void onKeyDown() {}

  void onKeyRight() {}
}
