## 2.2.0 - 2023-02-20
- Adds willRestartPreview api function, which sends channel method with same name, 
  which is handled by Windows platform.

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
