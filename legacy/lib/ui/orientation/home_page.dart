import 'package:flutter/material.dart';
import 'package:marozi/data/constants.dart';
import 'package:marozi/ui/landscape/homepage/landscape_home_page.dart';
import 'package:marozi/ui/portrait/homepage/portrait_home_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Constants.width = MediaQuery.of(context).size.width;
    Constants.height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait
        ? PortraitHomePage()
        : LandscapeHomePage();
  }
}
