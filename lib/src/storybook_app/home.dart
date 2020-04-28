import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import '../storybook_data.dart';

import 'color_palette.dart';
import 'tree_view.dart';
import 'canvas/canvas.dart';

class StorybookHome extends StatelessWidget {
  final String packageName;
  final StorybookData storybookData;

  StorybookHome({this.packageName, this.storybookData});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SingleChildScrollView(
            child: Container(
                width: TreeView.itemWidth,
                child: TreeView(node: toNode(storybookData)))),
        VerticalDivider(width: 1, thickness: 0, color: ColorPalette.slateGrey),
        Expanded(child: Canvas(storybookData: storybookData))
      ],
    );
  }

  Node toNode(StorybookData storybookData) {
    final rootNode = Node(
        key: 'root',
        label: packageName,
        kind: NodeKind.package,
        depth: 0,
        children: []);

    for (var item in storybookData.storiesDataMap.entries) {
      final data = item.value;
      final fileNode = Node(
          key: item.key,
          label: p.basenameWithoutExtension(data.path),
          kind: NodeKind.file,
          depth: 1,
          children: data.storiesNames
              .map((storyName) => Node(
                  key: '${item.key}|$storyName',
                  label: storyName,
                  kind: NodeKind.story,
                  depth: 2,
                  children: []))
              .toList());

      rootNode.children.add(fileNode);
    }

    return rootNode;
  }
}
