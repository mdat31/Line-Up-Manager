import 'package:flutter/material.dart';

class TextFix extends StatelessWidget {
  final String text;

  TextFix(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black54,
      ),
    );
  }
}
