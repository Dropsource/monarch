# Monarch CLI (Command Line Interface)

_The [Monarch Architecture](https://github.com/Dropsource/monarch/wiki/Monarch-Architecture)_ 
_document provides an overview of the Monarch CLI._

### Running tests
1. Generate the mocks
```
cd cli
dart run build_runner build
```
2. Run tests
```
cd cli
dart test
```

### Building the CLI
```
dart tools/build_cli.dart
```
