## 2.4.0-pre.5 - 2022-09-02
- Fix `dart analyze` issues
- Run `dart format .`

## 2.4.0-pre.3 - 2022-09-02
- Update major versions of analyzer and vm_service dependencies

## 2.4.0-pre.2 - 2022-08-03
- v2 hot reload and hot restart
- Get state from controller
- `MonarchDataManager` encapsulates `MonarchData`

## 2.4.0-pre.1
- Use package monarch_channels.
- Support for Monarch v2 architecture.

## 2.3.0-pre.1 - 2022-03-22
- Support new Flutter binding interfaces changed in Flutter version 2.12.0-4.1.pre

## 2.2.0 - 2022-03-07
- Update versions of packages analyzer and vm_service.

## 2.1.2 - 2022-01-20
- README update.

## 2.1.0 - 2022-01-11
- MonarchScrollBehavior to simulate drag gestures with the mouse
- Reassemble (i.e. hot reload) using MonarchBinding.
- Reset story channel method. 
- Generate MonarchData code using getters instead of final static variables.
- Support getters or const for code elements annotated with 
  @MonarchLocalizations and @MonarchTheme.
- Print warnings during code generation and monarch data validation.
- Remove localizations validation and loader status, any localizations 
  errors are handled as expected by error handling code.
- Simplify MaterialApp composition to avoid changing widget tree as 
  localizations are added or removed.
- Simplify StoryApp.
- Simplify MonarchStoryView: use UniqueKey instead of ValueKey. Framework should 
  always render a fresh story.

## 2.0.0 - 2021-10-19
- Handle common Flutter error "RenderBox was not laid out" by showing a placeholder
  error view (MonarchStoryErrorView), which prevents secondary errors from 
  polluting the experience.
- Handle gesture mouse tracker secondary errors.
- Capture unhandled errors. Throttle error messages.
- Reduce noise by only printing the first error of a story in full, unless verbose is set.
- Lock platform events until after MonarchStoryApp has been rendered. Fixes 
  errors when interacting with the story window during a reload.
- Reset Flutter Errors count when a new story is selected.
- Add new device definitions: iPhone 13, new iPads, new Android devices.
- Improve error capture and error output
- Visual debug flags
- Update major versions of packages vm_service and analyzer
- Prefix Monarch widgets
- Simplify Monarch widget tree
- Use lints instead of pedantic

## 1.1.0 - 2021-10-19
- All changes from version 2.0.0 but compatible with older Flutter SDK versions 
  (prior to Flutter 2.4.0-4.0.pre)

## 1.0.1 - 2021-09-01
- Upgrade monarch_annotations and monarch_utils to ^1.0.0.

## 1.0.0 - 2021-08-25
- Pop navigator routes when StoryView state changes to close any modals, 
  alerts or pages that were pushed after the story was rendered.
- Scale the top-level MaterialApp widget to support scaling of modals and alerts
- Bumping version to 1.0.0 since API is stable and users depend on it already.

## 0.2.5 - 2021-07-13
- Scale story, i.e. zoom story.

## 0.2.4 - 2021-05-27
- Builder option to support code generation with null safety disabled.

## 0.2.3 - 2021-04-12
- Move builder dart file inside src directory so pana recognizes package as null safe
- Tweaks
- Bump vm_service to ^6.2.0

## 0.2.2 - 2021-03-31
- Update pubspec.yaml with more information.
- Upgrade monarch_utils to ^0.1.1.

## 0.2.1 - 2021-03-26
- When generating import paths, if input file is in lib directory, use its URI, otherwise
  use its relative path.

## 0.2.0 - 2021-03-24
- Migrate to null safety.

## 0.1.3 - 2021-03-22
- Upgrading several dependencies to latest versions:
  +  build: ^2.0.0
  +  source_gen: ^1.0.0
  +  dart_style: ^2.0.0
  +  glob: ^2.0.0
  +  analyzer: ^1.1.0
- Getting ready for null safety.

## 0.1.2 - 2021-03-09
- Override theme's visualDependency to VisualDensity.standard.

## 0.1.1 - 2021-03-09
- Rolled back latest dependency updates. There were issues in users' projects due to 
  the dart null-safety transition. The current monarch dependencies should not cause 
  conflicts in users's projects.
- Flutter dependency conflicts documented [here](https://github.com/flutter/flutter/issues/77681).

## 0.1.0 - 2021-03-08
- Dependencies updates using Flutter 2.x.

## 0.0.35 - 2021-03-05
- Using Service URI path to connect to Dart VM.

## 0.0.34 - 2021-01-28
- Support text factor scale selection

## 0.0.33 - 2020-12-11
- Update list of devices.

## 0.0.32 - 2020-10-29
- Upgrade `source_gen` dependency to `^0.9.8` to allow syntax errors in builders.

## 0.0.31 - 2020-10-06
- Upgrade `build` and `analyzer` dependencies to `^1.5.0` and `^0.40.4` respectively

## 0.0.30 - 2020-08-06
- Debug Paint support

## 0.0.29 - 2020-08-05
- Remove debug banner

## 0.0.28 - 2020-08-03
- Update to monarch_utils 0.0.14

## 0.0.27 - 2020-07-28
- Refactor locale loading code to improve progress reporting
- Bug fixes
- Ready signal improvement between mac app and flutter story app

## 0.0.26 - 2020-07-21
- MonarchLocale generates corresponding Locale objects
- Using top-level element instead of class element for MonarchLocalizations annotation

## 0.0.25 - 2020-07-21
- Localizations support via MonarchLocalizations annotation

## 0.0.24 - 2020-07-07
- Use latest version of monarch_utils

## 0.0.23 - 2020-07-02
- Formatting

## 0.0.22 - 2020-07-01
- Publish tweak

## 0.0.21 - 2020-07-01
- Added homepage
- Update monarch_* dependencies to pub.dev

## 0.0.18 - 2020-07-01
- Monarch Alpha Release.

## 0.0.17 - 2020-06-15
- Alpha Release.
