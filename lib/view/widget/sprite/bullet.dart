import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:game/extension/extensions.dart';
import 'package:game/state/app_state.dart';
import 'package:game/view/ui/my_game.dart';
import 'package:game/view/widget/sprite/fish.dart';

class Bullet extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  Bullet({
    required Vector2 position,
    required double angle,
    required this.widthScreen,
    required this.heightScreen,
    required this.state,
    required this.onColl
  }) : super(
    position: Vector2(position.x - sizeBullet.x / 2, position.y),
    size: sizeBullet,
    angle: angle
  ) {
    velocity = Vector2(baseSpeed * sin(angle), -baseSpeed * cos(angle));
  }

  AppState state;
  ValueChanged<Vector2> onColl;
  Vector2 velocity = Vector2.zero();
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
    sprite = Sprite(game.images.fromCache('Bullet/bullet.png'));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (state.isPlay) {
      _movement(dt);
    }

    super.update(dt);
  }

  @override
  Future<void> onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    if (other is Fish) {
      other.collidedWithBullet();
      onColl.call(position);
      if (!collected) {
        collected = true;
        removeFromParent();
      }
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  void _movement(dt) {
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;

    if (position.x < -size.y || position.x > widthScreen + size.y || position.y < -size.y) {
      removeFromParent();
    }
  }
}
