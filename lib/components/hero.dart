import 'dart:async' as asc;

import 'package:flame/components.dart';
import 'package:flappy_bird/data/providers/sfx_provider.dart';
import 'package:flappy_bird/utills/extensions.dart';
import 'package:flutter/painting.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';
import '../r.dart';

class Hero extends PositionComponent with HasGameRef {
  final mainGameProvider = getIt.get<MainGameProvider>();
  final sfxProvider = getIt.get<SfxProvider>();

  double currentAngle = 0;
  double angleAcceleration = 0.08;
  double gravityAcceleration = 0;
  double gravity = 1;
  SpriteAnimationComponent? player;
  Vector2 spriteSize = Vector2(
    32 * 1.4,
    24 * 1.4,
  );
  asc.Timer? debouncer;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    size = spriteSize;
    position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2);

    final sprites = [
      Sprite.load(AssetImages.yellowbirdUpflap.fileName),
      Sprite.load(AssetImages.yellowbirdMidflap.fileName),
      Sprite.load(AssetImages.yellowbirdDownflap.fileName),
    ];
    final animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.1,
      loop: true,
    );
    player = SpriteAnimationComponent(
      animation: animation,
      size: spriteSize,
    );
  }

  void resetState() {
    angle = 0;
    currentAngle = 0;
    position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2);
    angleAcceleration = 0.05;
    gravityAcceleration = 0;
    gravity = 1;
  }

  void flap() {
    sfxProvider.playWingSfx();

    if (!mainGameProvider.startGame) mainGameProvider.startGame = true;
    currentAngle = -0.4;
    gravityAcceleration = 0.1;
    angleAcceleration = 0;
    gravity = -8;

    if (debouncer?.isActive ?? false) debouncer?.cancel();
    debouncer = asc.Timer(const Duration(milliseconds: 300), () {
      angleAcceleration = 0.08;
    });
  }

  @override
  void update(double dt) {
    if (mainGameProvider.startGame) {
      gravityAcceleration -= 0.04;
      gravity -= gravityAcceleration;
      currentAngle += angleAcceleration;
      if (currentAngle > 1.5) currentAngle = 1.5;
      if (gravity > 24) gravity = 24;

      y += gravity;
      angle = currentAngle;

      if (y > gameRef.size.y - 160 - ((24 * 1.4) / 2)) {
        sfxProvider.playHitSfx();
        game.camera.shake(intensity: 2);
        y = gameRef.size.y - 160 - ((24 * 1.4) / 2);
        mainGameProvider.startGame = false;
        mainGameProvider.gameOver = true;
      }
    }

    if (!mainGameProvider.gameOver) player?.update(dt);
  }

  @override
  void render(Canvas canvas) {
    player?.render(canvas);
  }
}
