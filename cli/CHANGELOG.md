## 3.1.0 - 2025-03-10
- Upgrades monarch_* package dependencies
- Sets dart sdk constraint to ^3.2.0

## 3.0.5 - 2023-10-06
- Use monarch_grpc 2.3.1
- Detect performance overlay error and print solution

## 3.0.4 - 2023-10-05
- Update monarch package compatibility to 3.6.0

## 3.0.3 - 2023-03-24
- Support Flutter 3.9.0-x.x.pre

## 3.0.2 - 2023-03-17
- Command to extract monarch linux tarball

## 3.0.1 - 2023-02-20
- Detect hot reload crash and notify user of workaround
- Use monarch_grpc 2.2.0

## 3.0.0 - 2023-01-27
- Linux support

## 2.1.4 - 2022-11-15
- Include project config in notification request context
- Validate compatibility with Flutter 2.x 

## 2.1.3 - 2022-11-14
- Update monarch package compatibility to 3.0.0

## 2.1.2 - 2022-11-04
- Discovery service
- Notifications service
- Use preview_api service
- Build tweaks
- Update init sample code in sample_button.dart

## 2.1.1 - 2022-09-22
- On windows: kill controller window by title

## 2.1.0 - 2022-09-08
- GRPC implementation
- Other fixes

## 2.0.0 - 2022-04-12
- Prep for orchestration of new Monarch architecture
- Move to new repo
- Migrate from pedantic to lints
- Support new VM service connection message and also support the legacy 
  Observatory message.

## 1.10.5 - 2022-03-30
- Analytics changes

## 1.10.4 - 2022-03-23
- Improve upgrade validator messaging and tests

## 1.10.3 - 2022-03-22
- init should use monarch package 2.3.0-pre.1 based on flutter version
- Use /version/upgrade to request version info for upgrade
- Validate monarch installation before upgrade
- Fix user messages of version api exceptions
- Fix tests

## 1.9.1 - 2022-03-08
- upgrade command moves old binaries instead of deleting them
- Remove youtube link

## 1.9.0 - 2022-03-07
- init command adds monarch 2.2.0 to pubspec.yaml

## 1.8.0 - 2022-02-08
- Rely on packages_config.json instead of .packages to find flutter executable

## 1.7.14 - 2022-01-13
- Check if stdin is attached to interactive terminal. 

## 1.7.13 - 2022-01-11
- Compatibility with released version of monarch package 2.1.0.

## 1.7.12 - 2022-01-04
- cli_usage_doc script prints content for /docs/cli-usage

## 1.7.10 - 2021-12-17
- Use elasticsearch credentials with more restricted access (monarch_cli user)
- Pass op_type when creating elasticsearch index docs
- Null check bug fix

## 1.7.8 - 2021-12-13
- Increate analytics queue wait timeout on exit
- Wait for newsletter_joined event to return, i.e. don't fire and forget the 
  newsletter_joined event.

## 1.7.7 - 2021-12-10
- Echo user keystroke if it is not a key command
- Ignore key commands if stories are reloading

## 1.7.6 - 2021-12-08
- Analytics for reload option.
- Fixes #85 (CLI seemed stuck after ui app was terminated): tasks can now stop 
  scraping messages and there are more final state checks in between each long
  running task initial setup.

## 1.7.4 - 2021-12-07
- Types to manage regen tasks, reload tasks, key commands.
- Updated user messaging.
- Validate minimum flutter version support.
- Remove support for monarch package 1.x.x.

## 1.7.0 - 2021-11-12
- Improve documentation of task runner tasks.
- `--on-save option` flag.
- Upgrade monarch_* dependencies to 1.x.
- Reloaded regex tweak.
- Handle hot reloading failed status.

## 1.6.14 - 2021-10-19
- Compatibility with released versions of monarch package 2.0.0 and 1.1.0.

## 1.6.13 - 2021-10-11
- Do not report warnings as crashes, unless the flag `--crash-debug` is set.
- Increase timeout to process analytics and crash reports when terminating.
- Improve exit message.

## 1.6.10 - 2021-10-08
- Process message markers from monarch app and flutter by line

## 1.6.9 - 2021-10-07
- Do not terminate CLI after app quits. Instead prompt user to terminate
  CLI manually. It fixes orphan dart processes which were left behind when
  terminating CLI automatically after quitting desktop app.

## 1.6.8 - 2021-10-04
- Document and update logic for writing log entries to stdout
- Update monarch package compatibility versions

## 1.6.7 - 2021-09-30
- DevTools discovery status
- Log monarch package version
- Project compatibility validation
- Monarch package compatibility based on flutter version

## 1.6.6 - 2021-09-29
- Launch DevTools for both macOS and Windows.
- Log file name and extension: log_monarch_cli.log
- Change local distribution to dist_local directory
- Improve parsing of desktop app stdout
- Update monarch package compatibility and init version to 1.1.0-pre.3
- Update build_runner init version to 2.1.0

## 1.5.0 - 2021-09-02
- Join newsletter interaction
- Manage two package:monarch versions, one for `monarch init` and the other one
  for the minimum compatibility check.
- package:monarch init version set to 1.0.1.
- Remove no-sound-null-safety version compatibility check.

## 1.4.0 - 2021-08-06
- Windows upgrade, fully automated, no more manual steps

## 1.3.3 - 2021-08-03
- Dock: user selection analytics

## 1.3.2 - 2021-07-13
- Story scale: analytics for selected story scale.
- Package `monarch` compatible version set to 0.2.5.
- Time out notifications read

## 1.2.0 - 2021-06-08
- Notifications: fetch notifications from api and display them (if any).

## 1.1.8 - 2021-05-27
- CLI flag `--no-sound-null-safety` to support projects that have disabled sound 
  null safety. 

## 1.1.7 - 2021-05-26
- Before project is validated:
  - Read the context info
  - Set the context info and session in the analytics and crash report builders
  - A previous fix was only reading the context

## 1.1.6 - 2021-05-26
- Fix process task error logging and wait for process stream to be done 

## 1.1.5 - 2021-05-24
- Handle `unknown` flutter channel
- Rename downloaded ui directory to unknown id directory

## 1.1.2 - 2021-05-14
- Handle scenarios where the monarch ui app or the generated flutter app write to stderr. 

## 1.1.1 - 2021-05-12
- Flutter version 2.3.0-1.0.pre changes the target-platform for macos. This version
  passes the expected target platform for Flutter version 2.3.0-1.0.pre or greater.

## 1.1.0 - 2021-05-11
- Monarch UI lazy downloads

## 1.0.0 - 2021-04-29
- Refactor several types to use types in monarch_http, monarch_utils and monarch_io_utils
- Migrate to null safety

## 0.2.12 - 2021-03-24
- Generating sample code that is compatible with null safe and non-null safe projects
- Bump monarch package min version to the one that is null safe

## 0.2.11 - 2021-03-22
- Passing build_runner flag `--delete-conflicting-outputs` via `monarch run`
- No need to bypass flutter branch in Flutter 2.x
- Improve try/catch of context info that gets MSBuild version

## 0.2.10 - 2021-03-12
- `monarch init` gitignores .monarch directory.

## 0.2.9 - 2021-03-09
- Removed Flutter 1.x compatibility logic. monarch package rolled back its dependency updates.
- monarch package compatibility set to 0.1.2

## 0.2.8 - 2021-03-08
- Fix version parsing

## 0.2.7 - 2021-03-08
- Send analytics to Elasticsearch
- Read Observatory URI from stdout
- Monarch package compatibility for flutter 1.x and 2.x

## 0.2.6 - 2021-02-25
- Moved request_utils functions to monarch_utils package

## 0.2.5 - 2021-01-28
- Analytics for text scale factor selection
- `monarch` package min version bump to `0.0.34`

## 0.2.4 - 2020-12-14
- `monarch init` command

## 0.2.3 - 2020-11-09
- Support `monarch upgrade` on windows.

## 0.2.2 - 2020-11-09
- Update context_info: track project name and rename platform_build_tool_info

## 0.2.1 - 2020-10-29
- Increase monarch package min version support to 0.0.32

## 0.2.0 - 2020-10-26
- Support for Windows operating system

## 0.1.0 - 2020-08-14
- Beta Release
- monarch_task_runner becomes monarch_cli
- Minor version bump to 0.1.0

## 0.0.13 - 2020-06-15
- Alpha Release