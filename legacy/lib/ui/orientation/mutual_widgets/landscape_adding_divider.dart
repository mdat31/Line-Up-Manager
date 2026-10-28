import 'package:flutter/material.dart';

class LandscapeAddingDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2, left: 6),
      child: Divider(
        indent: 0,
        endIndent: 10,
        thickness: 0.5,
        height: 0,
      ),
    );
  }
}
