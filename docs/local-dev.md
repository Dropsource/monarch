# Setting up your local development environment

The Monarch team has worked hard to make the contribution workflow easy. 
The Monarch repo has many build scripts which ease the contribution experience.

The build scripts can be run from macOS, Windows, or Linux. 

## Prerequisites
1. On macOS, make sure you have [Xcode](https://developer.apple.com/xcode/) installed.

   **Note**: The Xcode project is configured with the official Monarch signing identity.
   To build locally, open `platform/macos/monarch_macos.xcodeproj` and change the Team
   in Signing & Capabilities to your own Apple Developer account. Don't commit this change.
2. On Windows, make sure you have [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/) 
   with the “Desktop development with C++” workload installed, including all of its default components.
3. On Linux, make sure you have the 
   [Additional Linux requirements](https://docs.flutter.dev/get-started/install/linux#additional-linux-requirements)
   and also install `sudo apt install lib32stdc++-12-dev` ([Flutter documentation issue](https://github.com/flutter/website/issues/8016)).

## Local setup
The steps below will help you set up Monarch in your local environment.

### Set up your local repo
1. Clone this repo to your local environment.

2. Create a `cli/lib/settings.dart` file with these contents:
```dart
const kDeployment = 'local';
const kElasticsearchEndpoint = '';
const kElasticsearchUsername = '';
const kElasticsearchPassword = '';
const kVersionApiUrl = '';
```

3. Create a file `tools/local_settings.yaml`, and declare the paths to the 
   local Flutter SDKs you want to use for Monarch:
```yaml
local_flutter_sdks:
  - /Users/bob/development/flutter-sdks/beta
  - /Users/bob/development/flutter-sdks/stable
```
Monarch Linux works on Flutter 3.9 or above. 

### Build Monarch locally
1. Run `dart pub get` inside the tools directory:
```sh
cd tools
dart pub get
```

2. From the monarch root directory, use the tools/build.dart script to build Monarch:
```sh
dart tools/build.dart all
```

The tools/build.dart script has many subcommands. To get more details run:

```sh
dart tools/build -h
```

The build script will output the built artifacts to the out directory.

### Run tests
1. Run all the Monarch tests:
```sh
dart tools/test.dart
```

The tools/test.dart script accepts many arguments. To get more details run:
```sh
dart tools/test.dart -h
```

### Run Monarch
7. Run the version of Monarch you just built against a new Flutter project:
```sh
flutter create my_project
cd my_project
/path/to/out/monarch/bin/monarch init
/path/to/out/monarch/bin/monarch run --verbose
```

To make things easier, you could add the `out/monarch/bin` directory to your PATH.
