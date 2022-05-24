///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/foundation.dart';
import 'package:monarch_controller/widgets/tree_view/primitives/key_provider.dart';

/// A controller for a tree state.
///
/// Allows to modify the state of the tree.
class TreeController {
  bool _allNodesExpanded;
  final Map<Key, bool> _expanded = <Key, bool>{};
  Key? selectedKey;
  final KeyProvider keyProvider;

  TreeController(this.keyProvider, {allNodesExpanded = true})
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

  bool onKeyLeft() {
    if (selectedKey == null || selectedKey is! NodeKey) {
      return false;
    }

    if (isNodeExpanded(selectedKey!)) {
      toggleNodeExpanded(selectedKey!);
      return true;
    }

    return false;
  }

  bool onKeyRight() {
    if (selectedKey == null || selectedKey is! NodeKey) {
      return false;
    }

    if (_expanded[selectedKey] == true) {
      return false;
    }

    toggleNodeExpanded(selectedKey!);
    return true;
  }

  bool onKeyUp() {
    if (selectedKey == null) {
      selectedKey = keyProvider.first();
      return true;
    } else {
      final oldKey = selectedKey;
      selectedKey = _prev(selectedKey!) ?? oldKey;
      return oldKey != selectedKey;
    }
  }

  bool onKeyDown() {
    if (selectedKey == null) {
      selectedKey = keyProvider.first();
      return true;
    } else {
      final oldKey = selectedKey;
      selectedKey = _next(selectedKey!) ?? oldKey;
      return oldKey != selectedKey;
    }
  }

  Key? _next(Key selectedKey) {
    final keys = keyProvider.keys;
    final index = keys.indexOf(selectedKey);

    if (index < 0 || index == keys.length - 1) {
      return null;
    }

    if (selectedKey is LeafKey) {
      //take next or current
      return keys[index + 1];
    } else {
      if (!isNodeExpanded(selectedKey)) {
        for (int a = index + 1; a < keys.length; a++) {
          if (keys[a] is NodeKey) {
            return keys[a];
          }
        }

        return null;
      } else {
        //take next or current
        return keys[index + 1];
      }
    }
  }

  Key? _prev(Key selectedKey) {
    final keys = keyProvider.keys;
    final index = keys.indexOf(selectedKey);

    if (index <= 0) {
      return null;
    }

    final prevKey = keys[index - 1];
    if (prevKey is NodeKey) {
      return prevKey;
    } else {
      //look for the nearest node to check if its expanded
      for (int a = index - 2; a >= 0; a--) {
        final candidate = keys[a];
        if (candidate is LeafKey) {
          continue;
        }

        //found node
        if (!isNodeExpanded(candidate)) {
          return candidate;
        } else {
          //node is expanded, can return previous finding
          return keys[index - 1];
        }
      }
    }

    return null;
    // return index - 1 >= 0 ? keyProvider.keys[index - 1] : selectedKey;
  }
}
