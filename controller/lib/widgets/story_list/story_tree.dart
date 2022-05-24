import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monarch_controller/widgets/story_list/text_with_highlight.dart';
import 'package:monarch_controller/widgets/tree_view/flutter_simple_treeview.dart';

import '../../data/stories.dart';
import '../tree_view/primitives/key_provider.dart';

class StoryTree extends StatefulWidget {
  final Iterable<StoryGroup> filteredStories;
  final String query;
  final FocusNode? focusNode;
  final Function(Story)? onStorySelected;

  const StoryTree({
    Key? key,
    required this.filteredStories,
    this.focusNode,
    this.onStorySelected,
    this.query = '',
  }) : super(key: key);

  @override
  State<StoryTree> createState() => _StoryTreeState();
}

class _StoryTreeState extends State<StoryTree> {
  late TreeController treeController;

  @override
  void initState() {
    treeController = TreeController(KeyProvider());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TreeView(
        treeController: treeController,
        focusNode: widget.focusNode,
        nodes: widget.filteredStories
            .map((group) => TreeNode(
                  key: NodeKey(group.groupKey),
                  content: TextWithHighlight(
                    text: group.groupName,
                    highlightedText: widget.query,
                  ),
                  children: group.stories
                      .map(
                        (story) => TreeNode(
                          key: LeafKey(story.key),
                          onTap: () => widget.onStorySelected?.call(story),
                          content: Container(
                            padding: const EdgeInsets.only(
                              left: 40,
                              top: 4,
                              bottom: 4,
                              right: 8,
                            ),
                            child: TextWithHighlight(
                              text: story.name,
                              highlightedText: widget.query,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ))
            .toList());
  }
}
