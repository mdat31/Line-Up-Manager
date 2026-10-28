import 'package:flutter/material.dart';
import 'package:marozi/data/position/calculate_offset.dart';
import 'package:marozi/data/position/landscape_percentage.dart';

class LandscapeOffsetInitial {
  static List<Offset> _formation;

  static List<Offset> form_4_2_3_1(double width, double height) {
    _formation = CalculateOffset.getListOffset(
      width: width,
      height: height,
      percent: LandscapePercentage.percent_4_2_3_1,
    );
    return _formation;
  }

  static List<Offset> form_4_3_3(double width, double height) {
    _formation = CalculateOffset.getListOffset(
      width: width,
      height: height,
      percent: LandscapePercentage.percent_4_3_3,
    );
    return _formation;
  }

  static List<Offset> form_4_4_2(double width, double height) {
    _formation = CalculateOffset.getListOffset(
      width: width,
      height: height,
      percent: LandscapePercentage.percent_4_4_2,
    );
    return _formation;
  }
}
