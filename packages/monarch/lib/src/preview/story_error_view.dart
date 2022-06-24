import 'package:flutter/material.dart';

class MonarchStoryErrorView extends StatelessWidget {
  final String message;

  MonarchStoryErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red[900],
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(40),
                child: (Text(message,
                    style: TextStyle(
                        color: Colors.yellow, fontWeight: FontWeight.bold))))));
  }
}
