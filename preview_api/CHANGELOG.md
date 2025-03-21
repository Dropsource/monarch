## 2.5.1 - 2025-03-10
- Upgrades dependencies, dart sdk, and flutter sdk.
- Reads monarch.yaml

## 2.4.1 - 2023-11-02
- Use point versions for monarch_* packages.
- Using monarch_definitions `1.5.1` which rolls back Material 3 standard themes.

## 2.4.0 - 2023-10-23
- Use monarch_definitions `^1.5.0` which contains new Material 3 standard themes.

## 2.3.1 - 2023-10-06
- Use grpc 3.2.4.
- grpc 3.2.0 introduced `Server.create` and it required Dart 3.0. These changes are 
  an issue for Flutter versions that use Dart 2.x. Thus, the build script now applies 
  a patch to use grpc 3.1.0 with older flutter versions.
- Use monarch_grpc 2.3.1

## 2.3.0 - 2023-06-02
- Update list of device definitions

## 2.2.0 - 2023-02-20
- Adds willRestartPreview api function, which sends channel method with same name, 
  which is handled by Windows platform.
- Use monarch_grpc 2.2.0 and monarch_definitions 1.3.0

## 2.1.0 - 2023-01-30
- Linux support, use latest monarch_* dependencies

## 2.0.0 - 2022-12-21
- Track user selections using the preview api data (project data and selections state)
- Use monarch_grpc v2 which changes the signature of the 
  TrackUserSelection rpc on the MonarchPreviewApi service

## 1.0.1 - 2022-11-03
- Fix: update selections state correctly when story id is reset

## 1.0.0 - 2022-10-24
- Initial release of the preview_api
- Handles monarch channels preview methods
- Interfaces with preview via monarch channels
- Exposes preview functionality via grpc
- Stores monarch's reference data, project data and user selections
