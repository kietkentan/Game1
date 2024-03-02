import 'package:flutter/material.dart';

import 'indicator.dart';

class Loading extends StatefulWidget {
  Indicator indicator;
  double size;
  int length;
  int time;
  Color color;

  Loading({super.key, required this.indicator,  this.size = 20.0, this.length = 3, this.time = 100, this.color = Colors.white});

  @override
  State<StatefulWidget> createState() {
    return LoadingState(indicator);
  }
}

class LoadingState extends State<Loading> with TickerProviderStateMixin {
  Indicator indicator;

  LoadingState(this.indicator);

  @override
  void initState() {
    super.initState();
    indicator.context = this;
    indicator.updateLength(widget.length);
    indicator.lengthDuration = widget.time;
    indicator.start();
  }

  @override
  void dispose() {
    indicator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(indicator, widget.color),
      size: Size(widget.size * indicator.lengthBall, widget.size),
    );
  }
}

class _Painter extends CustomPainter {
  Indicator indicator;
  Color color;
  late Paint defaultPaint;

  _Painter(this.indicator, this.color) {
    defaultPaint = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..color = color
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    indicator.paint(canvas, defaultPaint, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}