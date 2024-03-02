import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:game/extension/extensions.dart';
import 'package:game/theme/text_styles/text_styles.dart';
import 'package:game/view/widget/sprite/bullet.dart';

import '../../state/app_state.dart';
import '../widget/sprite/fish.dart';

class MyGame extends FlameGame with TapDetector, HasCollisionDetection {
  final double height;
  final double width;
  final AppState state;
  final BuildContext context;
  final random = Random();
  ValueChanged<bool>? finalGame;

  MyGame({required this.height, required this.width, required this.state, required this.context, this.finalGame});

  @override
  Color backgroundColor() => const Color(0x00ffffff);

  @override
  void onTapDown(TapDownInfo info) async {
    super.onTapDown(info);
    if (state.isPlay && state.isAdd) {
      _spawnEffect(Offset(info.raw.globalPosition.dx, info.raw.globalPosition.dy));
      _timeClick();
    }
  }

  void resetGame() {
    removeWhere((component) => component is Fish || component is Bullet);
  }

  _timeClick() {
    state.isAdd = false;
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      state.isAdd = true;
    });
  }

  _spawnEffect(Offset position) {
    if (!state.subCoin()) return;
    switch (state.gun) {
      case 1:
        double angle = -atan((width / 2 - position.dx) / (height * 0.9 - position.dy));
        add(Bullet(
            position: Vector2(width / 2, height * 0.9),
            angle: angle,
            widthScreen: width,
            heightScreen: height,
            state: state,
            onColl: _onCollBullet
        ));
        break;
      case 2:
        double angle = -atan((width / 2 - position.dx) / (height * 0.9 - position.dy));
        add(Bullet(
            position: Vector2(width / 2 - height * 0.06, height * 0.9),
            angle: angle,
            widthScreen: width,
            heightScreen: height,
            state: state,
            onColl: _onCollBullet
        ));
        add(Bullet(
            position: Vector2(width / 2 + height * 0.06, height * 0.9),
            angle: angle,
            widthScreen: width,
            heightScreen: height,
            state: state,
            onColl: _onCollBullet
        ));
        break;
      case 3:
        double angle = -atan((width / 2 - position.dx) / (height * 0.9 - position.dy));
        add(Bullet(
            position: Vector2(width / 2 - height * 0.06, height * 0.9),
            angle: angle,
            widthScreen: width,
            heightScreen: height,
            state: state,
          onColl: _onCollBullet
        ));
        add(Bullet(
            position: Vector2(width / 2 + height * 0.06, height * 0.9),
            angle: angle,
            widthScreen: width,
            heightScreen: height,
            state: state,
            onColl: _onCollBullet
        ));
        add(Bullet(
            position: Vector2(width / 2, height * 0.85),
            angle: angle,
            widthScreen: width,
            heightScreen: height,
            state: state,
            onColl: _onCollBullet
        ));
        break;
    }
  }

  _onCollBullet(Vector2 pos) async {
    var ani = SpriteAnimationComponent(
      position: pos - Vector2.all(16),
        animation: SpriteAnimation.fromFrameData(
            images.fromCache('Bullet/collected.png'),
            SpriteAnimationData.sequenced(
                amount: 6,
                stepTime: 0.1,
                textureSize: Vector2.all(32),
                loop: false
            )
        )
    );
    add(ani);
    await ani.animationTicker?.completed;
    remove(ani);
  }

  _onCollFish(int heart) {
    state.coin += (heart * 1.5).round();
    state.kill -= 1;
    if (state.kill <= 0) {
      state.isPlay = false;
      if (state.thisLevel > state.level) {
        state.saveLevel(state.thisLevel);
      }
      state.saveCoin();
      finalGame?.call(true);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    var img = images.fromCache('bg_bottom.png');
    final blocks = SpriteComponent.fromImage(
      images.fromCache('bg_bottom.png'),
      priority: 10,
      position: Vector2(0, height - width * img.height / img.width),
      size: Vector2(width, width * img.height / img.width)
    );
    add(blocks);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (state.isPlay) {
      state.time -= dt * 1000;
      if (state.time <= 0 || state.coin <= 0) {
        state.isPlay = false;
        state.saveCoin();
        finalGame?.call(false);
      }
      _addFish();
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawDetail(canvas);
  }

  _addFish() {
    if (state.fish < 30) {
      int r = random.nextInt(50);
      if (r > 20 && r < 25) {
        add(Fish(
            fish: random.nextInt(listSizeFish.length) + 1,
            angle: random.nextDouble() * (2 * pi),
            widthScreen: width,
            heightScreen: height,
            state: state,
            onColl: _onCollFish
        ));
      }
    }
  }

  _drawDetail(Canvas canvas) {
    TextSpan textSpan = TextSpan(
        text: '${translation(context).kill_more}: ${state.kill}',
        style: TextStyles.textNunitoBold
            .copyWith(color: Colors.white, fontSize: 16));

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0);

    TextSpan textSpan2 = TextSpan(
        text:
            '${translation(context).time}: ${formatMillisecondsToTime(state.time.toInt())}',
        style: TextStyles.textNunitoBold
            .copyWith(color: Colors.white, fontSize: 16));

    TextPainter textPainter2 = TextPainter(
      text: textSpan2,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textPainter2.layout(minWidth: 0);

    textPainter.paint(
      canvas,
      Offset(10, height * 0.18),
    );
    textPainter2.paint(
      canvas,
      Offset(10, height * 0.18 + 20),
    );
  }
}
