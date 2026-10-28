import 'package:flutter/material.dart';
import 'package:marozi/data/constants.dart';
import 'package:marozi/data/position/landscape_offset_initial.dart';

class LandscapeOffsetUser {
  static List<Offset> offset_4_2_3_1 =
      LandscapeOffsetInitial.form_4_2_3_1(Constants.width, Constants.height);
  static List<Offset> offset_4_3_3 =
      LandscapeOffsetInitial.form_4_3_3(Constants.width, Constants.height);
  static List<Offset> offset_4_4_2 =
      LandscapeOffsetInitial.form_4_4_2(Constants.width, Constants.height);
}
