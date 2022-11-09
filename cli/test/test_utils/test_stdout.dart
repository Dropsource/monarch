import 'dart:convert';

import 'dart:io';

class TestStdout implements IOSink {
  final StringBuffer buffer = StringBuffer();

  TestStdout();

  @override
  late Encoding encoding = utf8;

  @override
  void write(Object? object) {
    buffer.write(object);
  }

  @override
  void writeln([Object? object = '']) {
    buffer.writeln(object);
  }

  @override
  void writeAll(Iterable objects, [String sep = '']) {
    buffer.writeAll(objects, sep);
  }

  @override
  void add(List<int> data) {
    buffer.write(utf8.decode(data));
  }

  @override
  void addError(error, [StackTrace? stackTrace]) {
    buffer.writeln(error);
    buffer.writeln(stackTrace);
  }

  @override
  void writeCharCode(int charCode) {
    buffer.write(String.fromCharCode(charCode));
  }

  @override
  Future addStream(Stream<List<int>> stream) async {
    await for (var data in stream) {
      buffer.write(utf8.decode(data));
    }
  }

  @override
  Future flush() => Future.value();
  @override
  Future close() => Future.value();
  @override
  Future get done => Future.value();
}
