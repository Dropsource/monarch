///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/material.dart';

class NodeKey extends ValueKey {
  const NodeKey(dynamic value) : super(value);
}

class LeafKey extends ValueKey {
  const LeafKey(dynamic value) : super(value);
}

/// Provides unique keys and verifies duplicates.
class KeyProvider {
  final List<Key> _keys = <Key>[];

  List<Key> get keys => _keys;

  Key key(Key? originalKey) {
    if (originalKey == null) {
      throw ArgumentError('Passing key to Tree node is required!');
    }
    if (_keys.contains(originalKey)) {
      throw ArgumentError('There should not be nodes with the same kays. '
          'Duplicate value found: $originalKey.');
    }
    _keys.add(originalKey);
    return originalKey;
  }

  void clear() {
    _keys.clear();
  }

  Key first() => _keys.first;
}
