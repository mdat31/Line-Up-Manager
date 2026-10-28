import 'package:flutter/material.dart';
import 'package:marozi/ui/landscape/detail/landscape_detail.dart';
import 'package:marozi/ui/portrait/detail/portrait_detail.dart';

class PlayerDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait
        ? PortraitPlayerDetail()
        : LandscapePlayerDetail();
  }
}
