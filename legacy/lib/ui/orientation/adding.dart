import 'package:flutter/material.dart';
import 'package:marozi/ui/landscape/adding/landscape_adding.dart';
import 'package:marozi/ui/portrait/adding/portrait_adding.dart';

class Adding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait
        ? PortraitAdding()
        : LandscapeAdding();
  }
}
