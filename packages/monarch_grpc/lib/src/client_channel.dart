import 'dart:io';

import 'package:grpc/grpc.dart';

String get clientLocalhost {
  if (Platform.isMacOS) {
    return '0.0.0.0';
  } else if (Platform.isWindows) {
    return 'localhost';
  } else {
    throw UnsupportedError(
        'The ${Platform.operatingSystem} platform is not supported');
  }
}

const clientChannelOptions =
    ChannelOptions(credentials: ChannelCredentials.insecure());

ClientChannel constructClientChannel(int port) =>
    ClientChannel(clientLocalhost, port: port, options: clientChannelOptions);
