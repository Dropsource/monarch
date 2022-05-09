import 'package:flutter/material.dart';
import 'package:monarch_controller/default_theme.dart';
import 'package:monarch_controller/widgets/components/text.dart';
import 'package:monarch_controller/widgets/controls_panel/controlls_panel.dart';
import 'package:monarch_controller/widgets/story_list/story_list.dart';
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/manager/controller_state.dart';

class WindowControllerScreen extends StatefulWidget {
  const WindowControllerScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final ControllerManager manager;

  @override
  State<StatefulWidget> createState() => UiWindowControllerState();
}

class UiWindowControllerState extends State<WindowControllerScreen> {
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
            if (snapshot.data == null) {
              return Container();
            }

            final state = snapshot.data!;

            return Container(
              width: double.infinity,
              //height: 600,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: darkGrey,
                      constraints: const BoxConstraints(minWidth: 280),
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: Column(
                        children: [
                          const TextHeadline5(
                            'story_list.title',
                            shouldTranslate: true,
                          ),
                          if (!state.isReady) ...[
                            const TextBody1(
                              'story_list.loading',
                              shouldTranslate: true,
                            ),
                          ],
                          if (state.isReady) ...[
                            Expanded(
                              child: StoryList(
                                projectName: state.monarchData == null
                                    ? ''
                                    : state.monarchData!.packageName,
                                stories: state.monarchData == null
                                    ? {}
                                    : state.monarchData!.metaStoriesMap,
                                activeStoryName: state.activeStoryName,
                                manager: manager,
                                onActiveStoryChange: (key, name) =>
                                    manager.onActiveStoryChanged(key, name),
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
                    ControlsPanel(
                      state: state,
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
