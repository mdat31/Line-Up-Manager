import 'package:flutter/material.dart';
import 'package:marozi/ui/landscape/table/landscape_table.dart';
import 'package:marozi/ui/portrait/table/portrait_table.dart';

class PlayerTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait
        ? PortraitTable()
        : LandscapeTable();
  }
}
