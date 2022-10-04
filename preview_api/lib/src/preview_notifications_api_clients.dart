import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

class PreviewNotifications {
  /// TODO: maybe lazily populated using the Discovery Api hosted by cli
  List<MonarchPreviewNotificationsApiClient> clientList = [];

  void defaultTheme(MetaThemeDefinition theme) {
    for (var client in clientList) {
      client.defaultTheme(ThemeInfo(
          id: theme.id, name: theme.name, isDefault: theme.isDefault));
    }
  }

  void launchDevTools() {
    // TODO: implement launchDevTools
    throw UnimplementedError();
  }

  void previewReady() {
    for (var client in clientList) {
      client.previewReady(Empty());
    }
  }

  void projectLocales(List<MetaLocalizationDefinition> locales) {
    // TODO: implement projectLocales
    throw UnimplementedError();
  }

  void projectPackage(String packageName) {
    // TODO: implement projectName
    throw UnimplementedError();
  }

  void projectStories(Map<String, MetaStoriesDefinition> metaStoriesMap) {
    // TODO: implement projectStories
    throw UnimplementedError();
  }

  void projectThemes(List<MetaThemeDefinition> themes) {
    // TODO: implement projectThemes
    throw UnimplementedError();
  }


  void toggleVisualDebugFlag(VisualDebugFlagInfo request) {
    // TODO: implement toggleVisualDebugFlag
    throw UnimplementedError();
  }

  void trackUserSelection(UserSelectionData request) {
    // TODO: implement trackUserSelection
    throw UnimplementedError();
  }

  void userMessage(UserMessageInfo request) {
    // TODO: implement userMessage
    throw UnimplementedError();
  }

  void vmServerUri(Uri uri) {
    for (var client in clientList) {
      client.vmServerUri(UriInfo(
          scheme: uri.scheme, host: uri.host, port: uri.port, path: uri.path));
    }
  }
}

final previewNotifications = PreviewNotifications();
