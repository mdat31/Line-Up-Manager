import 'package:flutter/material.dart';
import 'package:marozi/ui/landscape/position/landscape_dialog_setting.dart';
import 'package:marozi/ui/portrait/position/portrait_dialog_setting.dart';

class DialogSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Orientation.portrait == MediaQuery.of(context).orientation
        ? PortraitDialogSetting()
        : LandscapeDialogSetting();
  }
}
