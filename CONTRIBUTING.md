## WIP

After cloning this repo:

1. Create a file tools/local_settings.yaml, and populate it with the paths to your 
   local flutter sdks:
```
local_flutter_sdks:
  - /Users/bob/development/flutter-sdks/beta
  - /Users/bob/development/flutter-sdks/stable
```

2. Build all the monarch modules:
```
$ dart tools/build.dart
```

If you want to build a specific module, then you can run either of these scripts:
```
$ dart tools/build_cli.dart
$ dart tools/build_controller.dart
$ dart tools/build_platform.dart
```

The build scripts will output the built artifacts to the out directory.

3. Run monarch against an existing or new flutter project:
```
// use flutter beta channel for now
$ flutter create my_project
$ cd my_project
$ /path/to/out/monarch/bin/monarch init
// edit pubspec.yaml so the monarch package is using your local directory
$ flutter pub get
$ /path/to/out/monarch/bin/monarch run --verbose
```
