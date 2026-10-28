import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget {
  final String text;

  TextInfo(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'no info',
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
    );
  }
}
