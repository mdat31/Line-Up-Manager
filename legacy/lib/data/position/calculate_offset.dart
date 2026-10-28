import 'dart:ui';

import 'package:flutter/material.dart';

class CalculateOffset {
  static double _dxPortrait(double width, double per) {
    return width * per / 100;
  }

  static double _dyPortrait(double height, double per) {
    return height * per / 100;
  }

  static List<Offset> getListOffset({
    @required double width,
    @required double height,
    @required List<Offset> percent,
  }) {
    List<Offset> offsets = [];
    for (int i = 0; i < 11; i++) {
      double dx = _dxPortrait(width, percent[i].dx);
      double dy = _dyPortrait(height, percent[i].dy);
      offsets.add(Offset(dx, dy));
    }
    return offsets;
  }
}
