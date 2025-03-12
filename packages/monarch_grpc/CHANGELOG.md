### 2.4.1 - 2025-03-10
- Upgrades monarch_definitions dep

### 2.4.0 - 2025-03-06
- Upgrades major versions of dependencies: grpc, protobuf, lints
- Sets sdk constraint to ^3.2.0

### 2.3.1 - 2023-10-06
- Use grpc version 3.2.4

### 2.3.0 - 2023-09-27
- Add rpc support for performance overlay in monarch preview

### 2.2.0 - 2023-02-20
- WillRestartPreview rpc

### 2.1.0 - 2023-01-27
- Linux support

### 2.0.0 - 2022-12-22
- Change TrackUserSelection rpc on the MonarchPreviewApi service

### 1.0.0 - 2022-10-27
- Initial release of monarch_grpc
- Services: MonarchPreviewApi, MonarchPreviewNotificationsApi and MonarchDiscoveryApi
- Utility function to create monarch client channels
- Mappers to map monarch definitions to grpc messages (i.e. info object)
