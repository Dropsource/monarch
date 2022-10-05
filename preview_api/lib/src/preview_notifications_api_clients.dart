import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

class PreviewNotifications {
  /// TODO: maybe lazily populated using the Discovery Api hosted by cli
  List<MonarchPreviewNotificationsApiClient> clientList = [];

  // Future<T> Function(StartHeartbeatFunction) fn
  void _notifyClients(
      void Function(MonarchPreviewNotificationsApiClient client)
          notificationFn) {
    for (var client in clientList) {
      notificationFn(client);
    }
  }

  void defaultTheme(MetaThemeDefinition theme) {
    _notifyClients((client) => client.defaultTheme(
        ThemeInfo(id: theme.id, name: theme.name, isDefault: theme.isDefault)));
  }

  void launchDevTools() {
    _notifyClients((client) => client.launchDevTools(Empty()));
  }

  void previewReady() {
    _notifyClients((client) => client.previewReady(Empty()));
  }

  void projectLocales(List<MetaLocalizationDefinition> localizations) {
    _notifyClients((client) => client.projectLocalizations(LocalizationListInfo(
        localizations: localizations.map((e) => LocalizationInfo(
            localeLanguageTags: e.localeLanguageTags,
            delegateClassName: e.delegateClassName)))));
  }

  void projectPackage(String packageName) {
    _notifyClients(
        (client) => client.projectPackage(PackageInfo(name: packageName)));
  }

  void projectStories(Map<String, MetaStoriesDefinition> metaStoriesMap) {
    _notifyClients((client) => client.projectStories(StoriesMapInfo(
        storiesMap: metaStoriesMap.map((key, value) => MapEntry(
            key,
            StoriesInfo(
                package: value.package,
                path: value.path,
                storiesNames: value.storiesNames))))));
  }

  void projectThemes(List<MetaThemeDefinition> themes) {
    _notifyClients((client) => client.projectThemes(ThemeListInfo(
        themes: themes.map((e) =>
            ThemeInfo(id: e.id, name: e.name, isDefault: e.isDefault)))));
  }

  void toggleVisualDebugFlag(VisualDebugFlag flag) {
    _notifyClients((client) => client.toggleVisualDebugFlag(
        VisualDebugFlagInfo(name: flag.name, isEnabled: flag.isEnabled)));
  }

  void trackUserSelection(UserSelectionData request) {
    _notifyClients((client) => client.trackUserSelection(request));
  }

  void userMessage(UserMessageInfo request) {
    _notifyClients((client) => client.userMessage(request));
  }

  void vmServerUri(Uri uri) {
    _notifyClients((client) => client.vmServerUri(UriInfo(
        scheme: uri.scheme, host: uri.host, port: uri.port, path: uri.path)));
  }
}

final previewNotifications = PreviewNotifications();
