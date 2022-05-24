///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/material.dart';

import 'node_widget.dart';
import 'primitives/tree_controller.dart';
import 'primitives/tree_node.dart';

/// Builds set of [nodes] respecting [state], [indent] and [iconSize].
Widget buildNodes(Iterable<TreeNode> nodes, double? indent,
    TreeController state, double? iconSize) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var node in nodes)
        NodeWidget(
          treeNode: node,
          indent: indent,
          state: state,
          iconSize: iconSize,
          onNodeClicked: node.onNodeClicked,
        )
    ],
  );
}
