import 'package:flutter/material.dart';
import 'package:marozi/ui/landscape/export/landscape_export.dart';
import 'package:marozi/ui/portrait/export/portrait_export.dart';

class Export extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? PortraitExport()
        : LandscapeExport();
  }
}
