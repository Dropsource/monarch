# Monarch Architecture

This doc describes the architecture for Monarch version 2.x.

## Changelog
- 2022-04-01: Initial draft before implementation
- 2022-06-09: Review and re-organization
- 2022-11-07: Adjustment based on implementation

## Monarch Modules
Monarch is divided into 5 modules:

1. CLI
2. Platform Window Manager
3. Controller Window
4. Preview API
5. Preview Window

At runtime, these modules run on their own processes. The terms "monarch modules" and "monarch processes" may be used interchangeably.

### CLI
The Monarch CLI runs in a dart process. Its source code is inside the `cli` directory. The user invokes it using the command `monarch run`. 

The Monarch CLI orchestrates many processes and tasks required to run Monarch.

### Platform Window Manager
The Platform Window Manager, or simply Window Manager, is a native process. Its source code is re-written on each platform:

- On macOS it is written using Swift/Cocoa. 
- On Windows it is written using C++/Win32. 
- Linux support coming soon.

Its code is inside the `platform` directory, each platform has its own sub-directory. It is best to keep this code native so we can access the native APIs of each platform to manage windows. Also, the flutter shells are specific to each platform so we will always need some native code.

The Window Manager launches the Controller window, Preview window and Preview API. It also handles native window interactions like resize, move, docking, window title, etc.

### Controller Window
The Controller Window is a Flutter Window which renders UI controls and panels. The user uses the Controller to control the Preview window. Its code is inside the `controller` directory. 

The controller window renders a user interface for search; stories outline; selection of devices, themes, locales, etc; and in the future it will host add-ons.

### Preview Window
The Preview Window is a Flutter Window which renders the story selected in the Controller. Most of its code is inside the `packages/monarch` directory. At runtime, the [monarch package](https://pub.dev/packages/monarch) becomes the Preview window.

Some of the code for the Preview window is generated from the user's project source code (i.e. stories, themes and locales). 

In the future, there may be multiple preview windows if users want to see a story on multiple devices at the same time, or if they just want to see a story under different configurations.

### Preview API
The Preview API runs in a headless Flutter Engine (i.e. it doesn't have a window or UI). The Preview API exposes all the Preview Window functionality via gRPC endpoints. The Preview API maintains the state of the user selections. It can notify clients when user selections or project data changes. The Preview API interfaces with the Preview Window and the Platform Window Manager via [Flutter method channels](https://api.flutter.dev/flutter/services/MethodChannel-class.html).

The Controller controls the Preview Window via the Preview API. In the future, other clients, such as a CI job, can control the Preview via the Preview API.

## Monarch Data
There are 3 types of data that Monarch manages:

1. Reference data: such as device list, standard themes, scales, etc.
2. Project data: such as stories, user themes and locales.
3. User selections: such as selected device, selected theme, selected text scale factor, etc.

The Preview API hosts the reference data. The project data is generated from the user's project source code and it could change between reloads. And the user selections changes during normal Monarch usage, the Preview API stores the user selections state.

## Build
The CLI, the Preview API, the Controller and the Platform Window Manager are built into binaries which can be later distributed. The Preview is built by the CLI when Monarch launches.

The `tools` directory contains dart build scripts to build every Monarch module. 

### Build tools
- The CLI is built into a native executable using `dart compile exe`
- The Controller and Preview API are built into a flutter bundle using `flutter build bundle`
- The Window Manager is built into a desktop application executable. On macOS it uses `xcodebuild`, on Windows it uses `CMake`, on Linux it uses `(pending)`.

### Flutter SDK consistency
The Controller, Preview API and Window Manager depend on the Flutter SDK desktop libraries. Thus, at runtime, their Flutter SDK versions need to match. In other words, we cannot run a Controller using Flutter version X with a Window Manager using Flutter version Y. Due to this constraint, the build scripts build binaries of the Controller, Preview API and Window Manager for each Flutter SDK.

The build scripts will use the set of Flutter SDKs installed in the local machine where the build scripts are running. 

## Launch Sequence
To launch Monarch, a user executes `monarch run` inside of a Flutter project. At a high level, these are the launch sequence steps that Monarch executes:

1. The CLI generates code using the monarch package and the project's stories and source code.
2. The CLI then builds this generated code into the _preview bundle_.
3. The CLI then launches the Window Manager passing the path to the _preview bundle_, the _preview api bundle_ and the _controller bundle_.
4. The Window Manager launches the bundles into the Controller window, Preview API, and Preview window.

At this point, Monarch is ready for use.

## Runtime Communication
At runtime, the Monarch processes need to pass messages around. There are a few considerations when designing the communication between these processes:

- Do not bloat the monarch package with communication or RPC code. The monarch package is part of the users project, thus it should have as few dependencies as possible.
- gRPC is an ok choice, even for local processes. It is not as fast as native IPC but it is more than fast enough for our needs. Also, it gives us the option to move some of the processes to remote servers and it simplifies the code base.
- Future add-on requirements should be taken into account. Future add-ons will need to be notified when reference data, project data or user selections change. Future add-ons will also need to control the Preview.

### Messages between Preview API  and Preview Window
The preview api and preview window processes need to pass message to each other. To avoid bloating the monarch package with RPC code we instead use the built-in flutter method channels. 

The window manager sets up separate method channels with the api and window processes. The window manager then forwards messages from the preview api to the preview window and vice versa.

The code to forward these message is part of the native code, which is re-written on each platform. This message forwarding is mostly agnostic of the type of message, thus it won't need to be modified as we add new messages.

### Preview API, Notifications and Discovery
The Preview API may have multiple clients. Currently, the Controller and the CLI are the clients of the Preview API. These clients need to be notified of state changes. The Preview API notifies each client via the Preview Notifications API. Thus, the Controller and CLI implement their own Preview Notifications API.

The clients and the Preview API discover each other via the Discovery API which is implemented by the CLI. When each API service starts, it registers itself with the Discovery API, which allows its clients to discover each other.

Lastly, the Monarch integration tests also use the Preview API to exercise Monarch and 
to verify state.

