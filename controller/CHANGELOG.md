## 1.5.0 - 2025-03-10
- Upgrades dependencies and sdk
- Fixes lints

## 1.4.2 - 2024-01-17
- Use latest version of stockholm via fork

## 1.4.1 - 2023-11-02
- Use point versions for monarch_* packages.

## 1.4.0 - 2023-10-23
- Handle `FlutterError.onError` to log controller flutter errors to stdout
- Use latest monarch dependencies: monarch_definitions ^1.5.0, monarch_annotations ^1.0.4.

## 1.3.2 - 2023-10-06
- Use grpc 3.2.4
- grpc 3.2.0 introduced `Server.create` and it required Dart 3.0. These changes are 
  an issue for Flutter versions that use Dart 2.x. Thus, the build script now applies 
  a patch to use grpc 3.1.0 with older flutter versions.
- Use monarch_grpc 2.3.1

## 1.3.1 - 2023-06-02
- Do not use deprecated `iPhone13DeviceDefinition` from `monarch_definitions` package
- Use latest `monarch_definitions` version which has a new default device definition

## 1.3.0 - 2023-01-27
- Linux support
- Hide dock side on linux

## 1.2.0 - 2022-12-21
- To track user selection, only pass the selection kind to the preview api
- Debounce text scale factor selection tracking
- Wait a bit before tracking visual debug flag changes

## 1.1.0 - 2022-09-15
- update monarch package version which works with code and builds
- adjust ui controls
- polish ui, increase font size, align checkboxes vertically
- scrollable lists, update build_runner dependency
- dart analyze and dart format
- updated monarch dependencies
- fix stories
- comments and renaming of visual debug flag functions
- controller manager theme helper, update theme related state
- update stories mock
- handle main arguments, start controller grpc server, initialize cli grpc client
- set active story when monarch data changes, fix some naming

## 1.0.0 - 2022-05-28
- focus/unfocus color of slider
- treeview 
- focus improvements
- Tapping on the stories file should open / close, not just the arrow
- Search highlighting should be case agnostic
- monarch upgraded to 2.3.0
- stories
- tests for search manager
- mock channel method sender, more stories
- more advanced search algorithm with text highlight
- customized slider
- story list refactor
- localization fix
- stories, scale definitions, themes integration
- slider with a range
- left sidebar styled
- stockholm theme draft
- state handling refactor
- fonts and density updates
- window size fix
- supporting translations
- dev tools options
- device, theme, locale and text size selector
