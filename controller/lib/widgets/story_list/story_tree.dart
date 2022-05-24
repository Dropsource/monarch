import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monarch_controller/widgets/story_list/text_with_highlight.dart';

import '../../data/stories.dart';
import '../tree_view/primitives/tree_node.dart';
import '../tree_view/tree_view.dart';

class StoryTree extends StatelessWidget {
  final Iterable<StoryGroup> filteredStories;
  final String query;
  final FocusNode? focusNode;

  const StoryTree({
    Key? key,
    required this.filteredStories,
    this.focusNode,
    this.query = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TreeView(
        focusNode: focusNode,
        nodes: filteredStories
            .map((group) => TreeNode(
                  key: ValueKey(group.groupKey),
                  onTap: () {
                    //_requestFocus(context);
                    // widget.manager
                    //     .onGroupToggle(group.groupKey);
                  },
                  content: TextWithHighlight(
                    text: group.groupName,
                    highlightedText: query,
                  ),
                  children: group.stories
                      .map(
                        (story) => TreeNode(
                          key: ValueKey(story.key),
                          onTap: () {
                            //_requestFocus(context);
                            //todo change story to active
                          },
                          content:
                              // InkWell(
                              //   canRequestFocus: false,
                              //   onTap: () {
                              //     // _storyListFocusNode
                              //     //     .requestFocus();
                              //     // widget.onActiveStoryChange
                              //     //     ?.call(story.key);
                              //   },
                              //   child:
                              Container(
                            padding: const EdgeInsets.only(
                              left: 40,
                              top: 4,
                              bottom: 4,
                              right: 8,
                            ),
                            // color: widget.activeStoryKey ==
                            //     story.key
                            //     ? Colors.blue
                            //     : Colors.transparent,
                            child: TextWithHighlight(
                              text: story.name,
                              highlightedText: query,
                            ),
                          ),
                        ),
                        // ),
                      )
                      .toList(),
                ))
            .toList());
  }
}
