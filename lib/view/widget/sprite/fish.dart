import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:game/extension/extensions.dart';
import 'package:game/state/app_state.dart';
import 'package:game/view/ui/my_game.dart';

class Fish extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  Fish({
    required this.fish,
    required double angle,
    required this.widthScreen,
    required this.heightScreen,
    required this.onColl,
    required this.state
  }) : super(
      size: listSizeFish[fish - 1],
      angle: angle
  ) {
    baseHeart = Random().nextInt(listHeartFish[fish - 1]) + listHeartFish[fish - 1];
    heart = baseHeart;
    calculateVelocity();
  }

  AppState state;
  ValueChanged<int> onColl;
  int fish;
  Vector2 velocity = Vector2.zero();
  int heart = 2;
  int baseHeart = 2;
  double widthScreen;
  double heightScreen;
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    add(
        RectangleHitbox(
            position: Vector2.zero(),
            size: Vector2(size.x, size.y)
        )
    );
    sprite = Sprite(game.images.fromCache('Fish/fish_$fish.png'));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (state.isPlay) {
      _movement(dt);
    }

    super.update(dt);
  }

  calculateVelocity() {
    Random random = Random();
    int num = random.nextInt(2);
    if ((angle >= 0 && angle < pi / 2)) {
      flipHorizontallyAroundCenter();
      if (num == 1) {
        position = Vector2(widthScreen, heightScreen - random.nextInt(heightScreen.toInt()) + size.y);
      } else {
        position = Vector2(widthScreen - random.nextInt((widthScreen - size.x).toInt()), heightScreen);
      }
      velocity = Vector2(cos(angle) * baseFishSpeed, sin(angle) * baseFishSpeed);
    } else if (angle >= pi / 2 && angle < pi) {
      flipHorizontallyAroundCenter();
      flipVerticallyAroundCenter();
      if (num == 1) {
        position = Vector2(-size.x, heightScreen - random.nextInt(heightScreen ~/ 2));
      } else {
        position = Vector2(random.nextInt(widthScreen.toInt()) - size.x, heightScreen);
      }
      velocity = Vector2(cos(angle) * baseFishSpeed, sin(angle) * baseFishSpeed);
    } else if ((angle >= pi && angle < 1.5 * pi)) {
      flipHorizontallyAroundCenter();
      flipVerticallyAroundCenter();
      if (num == 1) {
        position = Vector2(random.nextInt(widthScreen.toInt()) - size.x, -size.y);
      } else {
        position = Vector2(-size.x, random.nextInt(heightScreen.toInt()) - size.y);
      }
      velocity = Vector2(cos(angle) * baseFishSpeed, sin(angle) * baseFishSpeed);
    } else {
      flipHorizontallyAroundCenter();
      if (num == 1) {
        position = Vector2(widthScreen, random.nextInt(heightScreen.toInt()) - size.y);
      } else {
        position = Vector2(random.nextInt(widthScreen.toInt()).toDouble(), -size.y);
      }
      velocity = Vector2(cos(angle) * baseFishSpeed, sin(angle) * baseFishSpeed);
    }
  }

  void _movement(dt) {
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;

    if (position.x < -2 * size.y || position.x > widthScreen + 2 * size.y || position.y < -2 * size.y || position.y > heightScreen + 2 * size.y) {
      state.fish -= 1;
      removeFromParent();
    }
  }

  collidedWithBullet() async {
    heart -= 1;
    if (heart <= 0 && !collected) {
      onColl.call(baseHeart);
      state.fish -= 1;
      collected = true;
      removeFromParent();
    }
  }
}
