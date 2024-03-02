import 'package:flutter/widgets.dart';

import 'loading.dart';

abstract class Indicator {
  late LoadingState context;
  late List<AnimationController> animationControllers;

  late int lengthBall;
  late int lengthDuration;

  paint(Canvas canvas, Paint paint, Size size);

  updateLength(int l);

  List<AnimationController> animation();

  void postInvalidate() {
    context.setState(() {});
  }

  void start() {
    animationControllers = animation();
    startAnims(animationControllers);
  }

  void dispose() {
    for (var i = 0; i < animationControllers.length; i++) {
      animationControllers[i].dispose();
    }
  }

  void startAnims(List<AnimationController> controllers) {
    for (var i = 0; i < controllers.length; i++) {
      startAnim(controllers[i]);
    }
  }

  void startAnim(AnimationController controller) {
    controller.repeat();
  }
}
