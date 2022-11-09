import 'dart:io';

// sample code below may be useful for auth
void main() {
  stdout.write('name: ');
  var name = stdin.readLineSync();

  stdin.echoMode = false;
  stdout.write('pass: ');
  var pass = stdin.readLineSync();

  stdout.writeln();
  stdout.writeln();

  stdout.writeln('name is $name');
  stdout.writeln('pass is $pass');
  stdout.writeln();
}
