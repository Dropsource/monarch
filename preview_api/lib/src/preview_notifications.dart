import 'package:monarch_grpc/monarch_grpc.dart';

import 'project_data.dart';
import 'selections_state.dart';

class PreviewNotifications {
  final MonarchDiscoveryApiClient discoveryClient;

  PreviewNotifications(this.discoveryClient);

  List<MonarchPreviewNotificationsApiClient> clientList = [];

  Future<void> _notifyClients(
      void Function(MonarchPreviewNotificationsApiClient client)
          notificationFn) async {
    await _populateClientList();
    for (var client in clientList) {
      notificationFn(client);
    }
  }

  Future<void> _populateClientList() async {
    if (clientList.length >= 2) {
      /// As of 2022-10-06, we only expect 2 clients.
      /// In the future, if we have more notification clients then we can
      /// increment this threshold or we can get more sophisticated about discovery.
      return;
    }

    var list = await discoveryClient.getPreviewNotificationsApiList(Empty());
    clientList.clear();
    for (var serverInfo in list.servers) {
      var channel = constructClientChannel(serverInfo.port);
      clientList.add(MonarchPreviewNotificationsApiClient(channel));
    }
  }

  void launchDevTools() {
    _notifyClients((client) => client.launchDevTools(Empty()));
  }

  void previewReady() {
    _notifyClients((client) => client.previewReady(Empty()));
  }

  void projectDataChanged(ProjectData projectData) {
    _notifyClients((client) => client.projectDataChanged(projectData.toInfo()));
  }

  void selectionsStateChanged(SelectionsState selectionsState) {
    _notifyClients(
        (client) => client.selectionsStateChanged(selectionsState.toInfo()));
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
