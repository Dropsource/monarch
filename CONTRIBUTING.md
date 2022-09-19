# Contributing to Monarch

The Monarch team has worked hard to make the contribution workflow easy. 
This repo has many build scripts which help you contribute changes 
to Monarch.

The scripts can be run from macOS or Windows. We hope to add Linux support
very soon.


## Set up your local environment
The steps below will help you set up Monarch in your local environment.

1. Clone this repo to your local environment.

2. Create a `cli/lib/settings.dart` file with these contents:
```dart
const DEPLOYMENT = 'local';
const ELASTICSEARCH_ENDPOINT = '';
const ELASTICSEARCH_USERNAME = '';
const ELASTICSEARCH_PASSWORD = '';
const VERSION_API_URL = '';
```

3. Create a file `tools/local_settings.yaml`, and declare the paths to the 
   local Flutter SDKs you want to use for Monarch:
```yaml
local_flutter_sdks:
  - /Users/bob/development/flutter-sdks/beta
  - /Users/bob/development/flutter-sdks/stable
```

4. Build all the monarch modules:
```sh
$ dart tools/build.dart
```

If you want to build a specific module, then you can run either of these scripts:
```sh
$ dart tools/build_cli.dart
$ dart tools/build_controller.dart
$ dart tools/build_platform.dart 
$ dart tools/build_internal.dart
```

The build scripts will output the built artifacts to the out directory.

5. Run the tests:
```sh
$ dart tools/run_tests.dart
```

6. Run the version of Monarch you just built against a new Flutter project:
```sh
$ flutter create my_project
$ cd my_project
$ /path/to/out/monarch/bin/monarch init
$ /path/to/out/monarch/bin/monarch run --verbose
```

To make things easier, you could add the `out/monarch/bin` directory to your PATH.


## Commit your changes
Monarch is composed of many modules and packages. Please group your commits by module 
or package. Also prefix your commit messages with the module or package name. 

For example, if you made changes to the cli source files, then your commit message could be 
"cli: some change" or "cli: some bug fix". If you made changes to the 
monarch package, then your commit message could be "monarch package: some change".

These are the prefixes we use in commit messages:

- cli
- controller
- macos
- windows
- monarch package
- monarch_utils package
- etc.

Also, please sign your commit messages.

Once your changes are ready, please submit a pull request.