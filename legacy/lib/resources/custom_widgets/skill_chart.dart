import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../colors.dart';

class MyChart extends StatelessWidget {
  final double maxValue;
  final List<double> data;
  final Size size;
  final double fallbackHeight;
  final double fallbackWidth;
  final List<String> labels;
  final bool showData;

  MyChart({
    Key key,
    @required this.maxValue,
    @required this.data,
    this.size = Size.infinite,
    this.fallbackWidth = 200,
    this.fallbackHeight = 200,
    this.labels,
    this.showData = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Offset> pixel2 = [
      Offset(10, 90),
      Offset(78, 140),
      Offset(148, 90),
      Offset(120, 6),
      Offset(33, 8),
    ];
    List<double> degrees = [
      37 / 360,
      286 / 360,
      360 / 360,
      70 / 360,
      324 / 360,
    ];
    return LimitedBox(
      maxWidth: fallbackWidth,
      maxHeight: fallbackHeight,
      child: labels != null
          ? Stack(
              overflow: Overflow.visible,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 13),
                  child: CustomPaint(
                    size: size,
                    painter: SkillChart(maxValue, data, showData),
                  ),
                ),
                ...Iterable<int>.generate(labels.length).map((i) {
                  return Positioned(
                    top: pixel2[i].dx,
                    left: pixel2[i].dy,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(degrees[i]),
                      child: Text(labels[i]),
                    ),
                  );
                }),
              ],
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 13),
              child: CustomPaint(
                size: size,
                painter: SkillChart(maxValue, data, showData),
              ),
            ),
    );
  }
}

class SkillChart extends CustomPainter {
  final double maxValue;
  final List<double> data;
  final bool showData;

  SkillChart(this.maxValue, this.data, this.showData);

  final Paint spokes = Paint()..color = Colors.black45;

  final Gradient gradient = new RadialGradient(
    center: Alignment.center,
    colors: <Color>[
      HexColor('FF8B37'),
      HexColor('FF6C02'),
    ],
    stops: [
      0.0,
      1.0,
    ],
  );

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = size.center(Offset(5, 5));

    double angle = (2 * pi) / data.length;

    var dataPoints = List<Offset>();

    for (var i = 0; i < data.length; i++) {
      var scaledRadius = (data[i] / maxValue) * center.dy;
      var x = scaledRadius * cos(angle * i - pi / 2);
      var y = scaledRadius * sin(angle * i - pi / 2);

      dataPoints.add(Offset(x, y) + center);
    }

    var outerPoints = List<Offset>();

    for (var i = 0; i < data.length; i++) {
      var x = center.dy * cos(angle * i - pi / 2);
      var y = center.dy * sin(angle * i - pi / 2);

      outerPoints.add(Offset(x, y) + center);
    }

//    if (labels != null) {
//      paintLabels(canvas, center, outerPoints, labels);
//    }

    if (showData) {
      paintDataPoints(canvas, dataPoints);
      paintDataLines(canvas, dataPoints);
    }
    paintGraphOutline(canvas, center, outerPoints);
  }

  void paintGraphOutline(Canvas canvas, Offset center, List<Offset> points) {
    for (var i = 0; i < points.length; i++) {
      if (i < points.length - 1) {
        canvas.drawLine(points[i], points[i + 1], spokes);
      } else {
        canvas.drawLine(points[i], points[0], spokes);
      }
    }
  }

  void paintDataPoints(Canvas canvas, List<Offset> points) {
    for (var i = 0; i < points.length; i++) {
      canvas.drawPoints(
          ui.PointMode.points, points, Paint()..color = Colors.orange);
    }
  }

  void paintDataLines(Canvas canvas, List<Offset> points) {
    Path path = Path()..addPolygon(points, true);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.orange
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill,
    );
  }

  Rect rect = new Rect.fromCircle(
    center: new Offset(85.0, 85.0),
    radius: 60.0,
  );

  void paintText(Canvas canvas, Offset center, List<Offset> points,
      List<double> data, Size size) {
    final textStyle = TextStyle(color: Colors.black, fontSize: 19);

    final textSpan = TextSpan(
      text: 'Hello',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);
    for (var i = 0; i < textSpan.text.length; i++) {
//      _drawLetter(canvas, textSpan.text[i], angle);
    }

    textPainter.paint(canvas, Offset(0, 0));
  }

  void paintLabels(
      Canvas canvas, Offset center, List<Offset> points, List<String> labels) {
    var textPainter = TextPainter(textDirection: TextDirection.ltr);
    var textStyle =
        TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold);

    for (var i = 0; i < points.length; i++) {
      textPainter.text = TextSpan(text: labels[i], style: textStyle);
      textPainter.layout();
      if (points[i].dx < center.dx) {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width + 5.0), -15));
      } else if (points[i].dx > center.dx) {
        textPainter.paint(canvas, points[i].translate(5.0, -15));
      } else if (points[i].dy < center.dy) {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width / 2), -18));
      } else {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width / 2), 20));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PainterLearn extends CustomPainter {
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    /// Paint Points
    // final pointMode = ui.PointMode.points;
    // Offset centerPoints = size.center(Offset.zero);
    // final pointsList = [
    //   centerPoints,
    // ];
    // final paintPoints = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = 2
    //   ..strokeCap = StrokeCap.round;

    /// Paint Rect
    final left = 50.0;
    final top = 100.0;
    final right = 150.0;
    final bottom = 200.0;
    // final rect = Rect.fromLTRB(left, top, right, bottom);
    // final paintRect = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = 2
    //   ..style = PaintingStyle.stroke;

    /// Paint Circle
    // final centerCircle = size.center(Offset(0, 0));
    // final radius = 100.0;
    // final paintCircle = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2;

    /// Paint Oval
    final rectOval = Rect.fromLTRB(50, 100, 250, 220);
    final paintOval = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    /// Paint Arcs
    final rectArcs = Rect.fromLTRB(50, 100, 250, 220);

    ///The startAngle is the location on the oval that the line starts
    /// drawing from. An angle of 0 is at the right side.
    /// Angles are in radians, not degrees. The top is at 3π/2 (or -π/2),
    /// the left at π, and the bottom at π/2.
    final startAngle = 3 * pi / 2;

    /// The sweepAngle is how much of the oval is included in the arc.
    /// Again, angles are in radians. A value of 2π would draw the entire oval.
    // final sweepAngle = pi;
    // final useCenter = false;
    // final paintArcs = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
