import 'package:grpc/grpc.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

import '../analytics/analytics.dart';
import '../utils/standard_output.dart';
import 'task_runner.dart';

class PreviewNotificationsApiService extends MonarchPreviewNotificationsApiServiceBase {
  final TaskRunner taskRunner;
  final Analytics analytics;

  PreviewNotificationsApiService(this.taskRunner, this.analytics);

  @override
  Future<Empty> trackUserSelection(ServiceCall call, UserSelectionData request) {
    analytics.user_selection({
      'locale_count': request.localeCount,
      'user_theme_count': request.userThemeCount,
      'story_count': request.storyCount,
      'selected_device': request.selectedDevice,
      'kind': request.kind,
      'selected_dock_side': request.selectedDockSide,
      'selected_text_scale_factor': request.selectedTextScaleFactor,
      'selected_story_scale': request.selectedStoryScale,
      'slow_animations_enabled': request.slowAnimationsEnabled,
      'show_guidelines_enabled': request.showGuidelinesEnabled,
      'show_baselines_enabled': request.showBaselinesEnabled,
      'highlight_repaints_enabled': request.highlightRepaintsEnabled,
      'highlight_oversized_images_enabled':
          request.highlightOversizedImagesEnabled,
    });
    return Future.value(Empty());
  }

  @override
  Future<Empty> userMessage(ServiceCall call, UserMessageInfo request) {
    stdout_default.writeln(request.message);
    return Future.value(Empty());
  }

  @override
  Future<Empty> vmServerUri(ServiceCall call, UriInfo request) {
    taskRunner.attachTask!.debugUri = Uri(
        scheme: request.scheme,
        host: request.host,
        port: request.port,
        path: request.path);

    return Future.value(Empty());
  }

  @override
  Future<Empty> launchDevTools(ServiceCall call, Empty request) {
    taskRunner.attachTask!.launchDevtools();
    return Future.value(Empty());
  }

  @override
  Future<Empty> previewReady(ServiceCall call, Empty request) {
    // do nothing
    return Future.value(Empty()); 
  }
  
  @override
  Future<Empty> projectDataChanged(ServiceCall call, ProjectDataInfo request) {
    // do nothing
    return Future.value(Empty()); 
  }
  
  @override
  Future<Empty> selectionsStateChanged(ServiceCall call, SelectionsStateInfo request) {
    // do nothing
    return Future.value(Empty()); 
  }
  
}