///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/material.dart';

/// One node of a tree.
class TreeNode {
  final List<TreeNode>? children;
  final Widget content;
  final Key? key;

  TreeNode({
    this.key,
    this.children,
    Widget? content,
  }) : content = content ?? const SizedBox(width: 0, height: 0);
}
