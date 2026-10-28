import 'package:flutter/material.dart';
import 'package:marozi/data/constants.dart';
import 'package:marozi/data/position/portrait_offset_initial.dart';

class PortraitOffsetUser {
  static List<Offset> offset_4_2_3_1 =
      PortraitOffsetInitial.form_4_2_3_1(Constants.width, Constants.height);
  static List<Offset> offset_4_3_3 =
      PortraitOffsetInitial.form_4_3_3(Constants.width, Constants.height);
  static List<Offset> offset_4_4_2 =
      PortraitOffsetInitial.form_4_4_2(Constants.width, Constants.height);
}
