# monarch_grpc

Contains gRPC interfaces for the Monarch CLI and the Monarch Controller.


### Install gRPC proto buffer compiler
1. Install the [Protocol Buffer Compiler](https://grpc.io/docs/protoc-installation/). 
    1. For Windows, [install the pre-compiled binaries](https://grpc.io/docs/protoc-installation/#install-pre-compiled-binaries-any-os).
    2. For macOS, you can install the pre-compiled binaries or use a package manager.
2. Install the Dart plugin for the protocol compiler:
```
$ dart pub global activate protoc_plugin
```

If you need further install instructions the [gRPC Dart Quick start](https://grpc.io/docs/languages/dart/quickstart/).


### Regenerate gRPC code
On macOS:
```
$ sh tools/gen_grpc.sh
```

On Windows:
```
PS> .\tools\gen_grpc.bat
```

### gRPC resources
- [gRPC Dart Reference](https://developers.google.com/protocol-buffers/docs/reference/dart-generated)
- [gRPC error details](https://github.com/grpc/grpc-dart/blob/master/lib/src/shared/status.dart). Link above includes mapping of HTTP status codes to gRPC status codes.
- [Protocol Buffers Well-Known Types](https://developers.google.com/protocol-buffers/docs/reference/google.protobuf)
