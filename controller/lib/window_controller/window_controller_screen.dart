import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';
import 'package:monarch_window_controller/window_controller/widgets/controls_panel/controlls_panel.dart';
import 'package:monarch_window_controller/window_controller/widgets/story_list/story_list.dart';
import 'package:monarch_window_controller/window_controller/window_controller_manager.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';

class WindowControllerScreen extends StatefulWidget {
  const WindowControllerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UiWindowControllerState();
}

class UiWindowControllerState extends State<WindowControllerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<WindowControllerState>(
          stream: manager.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            }

            final state = snapshot.data!;

            return Container(
              width: double.infinity,
              //height: 600,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
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
                          if (!state.active) ...[
                            const TextBody1(
                              'story_list.loading',
                              shouldTranslate: true,
                            ),
                          ],
                          if (state is ConnectedWindowControllerState) ...[
                            Expanded(
                              child: StoryList(
                                projectName: state.monarchData == null ? '' : state.monarchData!.packageName,
                                stories: state.monarchData == null ? {} : state.monarchData!.metaStoriesMap,
                                activeStoryName: state.activeStoryName,
                                onActiveStoryChange: (name) =>
                                    manager.onActiveStoryChanged(name),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (state is ConnectedWindowControllerState) ...[
                    ControlsPanel(state: state, manager: manager,),
                  ],
                ],
              ),
            );
          }),
    );
  }
}
