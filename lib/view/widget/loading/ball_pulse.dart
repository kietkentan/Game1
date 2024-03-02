import 'package:flutter/material.dart';

import 'indicator.dart';

class BallPulseIndicator extends Indicator {
  List<double> scaleDoubles = [];

  @override
  updateLength(int l) {
    lengthBall = l;
    scaleDoubles = List.filled(l, 0.0);
  }

  @override
  paint(Canvas canvas, Paint paint, Size size) {
    int length = scaleDoubles.length;
    var height = size.height;
    var x = height / 2;
    var y = height / 2;
    for (int i = 0; i < length; i++) {
      canvas.save();
      var translateX = x + height * i;
      canvas.translate(translateX, y);
      canvas.scale(scaleDoubles[i], scaleDoubles[i]);
      canvas.drawRect(Rect.fromLTWH(-height / 2, -height / 2, height, height), paint);
      canvas.restore();
    }
  }

  @override
  List<AnimationController> animation() {
    List<AnimationController> controllers = [];

    for (var i = 0; i < scaleDoubles.length; i++) {
      AnimationController sizeController = AnimationController(
          duration: Duration(milliseconds: lengthDuration * scaleDoubles.length), vsync: context);
      var delayedAnimation =
      Tween(begin: 0.0, end: 1.0).animate(sizeController);
      delayedAnimation.addListener(() {
        scaleDoubles[i] = delayedAnimation.value;
        postInvalidate();
      });
      controllers.add(sizeController);
    }
    return controllers;
  }

  @override
  void startAnim(AnimationController controller) {
    controller.repeat(reverse: true);
  }

  @override
  startAnims(List<AnimationController> controllers) async {
    for (var i = 0; i < controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: lengthDuration), () {
        if (context.mounted) startAnim(controllers[i]);
      });
    }
  }
}