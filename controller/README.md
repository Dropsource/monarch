# Monarch Controller

_The [Monarch Architecture](https://github.com/Dropsource/monarch/wiki/Monarch-Architecture)_ 
_document provides an overview of the Monarch Controller._

### Running tests
```
cd controller
flutter test
```

### Building the Controller
```
dart tools/build_controller.dart
```

### Running the Controller stories in Monarch
You can use Monarch to run the Monarch Controller stories. To run the Controller 
stories you may need to change the `monarch` package version in pubspec.yaml. The 
Monarch CLI you use to run the stories may require a specific monarch package version.

If you change the `monarch` package version, make sure to set it back to its original
version before you commit your changes.
The Controller build needs to be able to build the Controller with many Flutter 
SDK versions. Setting the `monarch` package to a lower version helps avoid any compatibility 
issues during Monarch builds.

```
cd controller
monarch run
```

### Patch for grpc 3.1.0
_Notes as of 20231006._
grpc 3.2.0 introduced `Server.create` and it required Dart 3.0. These changes present 
an issue for Flutter versions that use Dart 2.x (i.e. flutter versions prior to 3.8). 
Thus, the build script now applies a patch to use grpc 3.1.0 with older flutter versions.

The patch changes pubspec.yaml and lib/main.dart. If you need to change any of those 
files, then you will need to regenerate the git patch. To do so:

- first make your changes as normal and test them with a newer flutter version
- once your changes are good, commit your changes
- make sure your git directory is clean, i.e. you don't have any pending (not staged) changes
- now you can manually re-edit the changes to main.dart and pubspec.yaml so you can 
  regenerate the patch, take a look at the patch to see the changes we need
- write the diff to a new patch `git diff > grpc_310_x.patch`
- rename `grpc_310_x.patch` to `grpc_310.patch`
- git restore changes to main.dart and pubspec.yaml
- run the build scripts using older flutter version, anything before flutter 3.8 works
- commit grpc_310.patch