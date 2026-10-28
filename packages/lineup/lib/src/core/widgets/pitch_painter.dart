import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// Vertical half-and-half pitch markings, proportional to the paint size so
/// the same painter works on screen and in exported images.
class PitchPainter extends CustomPainter {
  const PitchPainter({required this.lineColor, this.strokeWidth = 1.5});

  final Color lineColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final w = size.width;
    final h = size.height;
    final inset = strokeWidth / 2;

    canvas
      ..drawRect(Rect.fromLTRB(inset, inset, w - inset, h - inset), paint)
      ..drawLine(Offset(0, h / 2), Offset(w, h / 2), paint)
      ..drawCircle(Offset(w / 2, h / 2), w * 0.14, paint);

    final boxW = w * 0.5;
    final boxH = h * 0.13;
    final goalW = w * 0.24;
    final goalH = h * 0.05;
    for (final top in [true, false]) {
      final y = top ? 0.0 : h;
      final dir = top ? 1.0 : -1.0;
      canvas
        ..drawRect(
          Rect.fromPoints(
            Offset((w - boxW) / 2, y),
            Offset((w + boxW) / 2, y + dir * boxH),
          ),
          paint,
        )
        ..drawRect(
          Rect.fromPoints(
            Offset((w - goalW) / 2, y),
            Offset((w + goalW) / 2, y + dir * goalH),
          ),
          paint,
        )
        ..drawArc(
          Rect.fromCircle(
            center: Offset(w / 2, y + dir * boxH),
            radius: w * 0.09,
          ),
          top ? 0 : math.pi,
          math.pi,
          false,
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(PitchPainter oldDelegate) =>
      lineColor != oldDelegate.lineColor ||
      strokeWidth != oldDelegate.strokeWidth;
}
