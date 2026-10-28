import 'package:flutter/material.dart';

class PreviewBnW extends StatefulWidget {
  @override
  _PreviewBnWState createState() => _PreviewBnWState();
}

class _PreviewBnWState extends State<PreviewBnW> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/blue_n_white.png',
          fit: BoxFit.fitWidth,
        ),
        Text('preview Blue and white'),
      ],
    );
  }
}
