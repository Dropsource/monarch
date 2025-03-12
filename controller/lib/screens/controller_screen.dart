import 'package:flutter/material.dart';

import '../default_theme.dart';
import '../widgets/components/text.dart';
import '../widgets/story_list/story_list.dart';
import '../manager/controller_manager.dart';
import '../manager/controller_state.dart';
import '../widgets/control_panel/control_panel.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({
    super.key,
    required this.manager,
  });

  final ControllerManager manager;

  @override
  State<StatefulWidget> createState() => UiWindowControllerState();
}

class UiWindowControllerState extends State<ControllerScreen> {
  late ControllerManager manager;

  @override
  void initState() {
    super.initState();
    manager = widget.manager;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ControllerState>(
          stream: manager.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null || !snapshot.data!.isReady) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: TextBody1(
                    'app.loading',
                    shouldTranslate: true,
                  ),
                ),
              );
            }

            final state = snapshot.data!;

            return SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: darkGrey,
                      constraints: const BoxConstraints(minWidth: 280),
                      padding: const EdgeInsets.only(
                        top: 0,
                      ),
                      child: Column(
                        children: [
                          if (!state.isReady) ...[
                            const TextBody1(
                              'story_list.loading',
                              shouldTranslate: true,
                            ),
                          ],
                          if (state.isReady) ...[
                            Expanded(
                              child: StoryList(
                                projectName: state.storyGroups.isEmpty
                                    ? ''
                                    : state.packageName,
                                stories: state.storyGroups,
                                activeStoryId: state.currentStoryId,
                                manager: manager,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                  ),
                  if (state.isReady) ...[
                    ControlPanel(
                      manager: manager,
                    ),
                  ],
                ],
              ),
            );
          }),
    );
  }
}
