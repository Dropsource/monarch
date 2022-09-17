# Monarch Controller

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
