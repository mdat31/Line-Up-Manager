import 'package:flutter/material.dart';

class TextSmallUpper extends StatelessWidget {
  final String text;

  TextSmallUpper(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      ' $text',
      style: TextStyle(
        fontSize: 13,
        color: Colors.black54,
      ),
    );
  }
}
