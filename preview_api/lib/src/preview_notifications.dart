import 'package:monarch_grpc/monarch_grpc.dart';

import 'project_data.dart';
import 'selections_state.dart';

class PreviewNotifications {
  final MonarchDiscoveryApiClient discoveryApi;

  PreviewNotifications(this.discoveryApi);

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
    var list = await discoveryApi.getPreviewNotificationsApiList(Empty());
    clientList.clear();
    for (var serverInfo in list.servers) {
      var channel = constructClientChannel(serverInfo.port);
      clientList.add(MonarchPreviewNotificationsApiClient(channel));
    }
  }

  void launchDevTools() {
    _notifyClients((client) => client.launchDevTools(Empty()));
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
