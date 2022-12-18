import 'dart:async' as asc;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/components/point_area.dart';
import 'package:flappy_bird/data/providers/sfx_provider.dart';
import 'package:flappy_bird/utills/extensions.dart';
import 'package:flutter/material.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';
import '../r.dart';
import 'pipe.dart';

class Bird extends PositionComponent with HasGameRef, CollisionCallbacks {
  final mainGameProvider = getIt.get<MainGameProvider>();
  final sfxProvider = getIt.get<SfxProvider>();

  double currentAngle = 0;
  double angleAcceleration = 0;
  double gravityAcceleration = 0;
  double gravity = 0;
  SpriteAnimationComponent? player;
  Vector2 spriteSize = Vector2(
    44.8,
    33.6,
  );
  asc.Timer? debouncer;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pipe) {
      gameOver();
    }
    if (other is PointArea) {}
    super.onCollision(intersectionPoints, other);
  }

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    size = spriteSize;
    position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2 - 80);

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
      anchor: Anchor.center,
      size: spriteSize,
    );
    add(RectangleHitbox(
      size: spriteSize * 0.8,
    ));
  }

  void resetState() {
    angle = 0;
    currentAngle = 0;
    position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2 - 80);
    angleAcceleration = 0;
    gravityAcceleration = 0;
    gravity = 0;
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
      final deltaTime = dt * 60;

      gravityAcceleration -= 0.04 * deltaTime;
      gravity -= gravityAcceleration * deltaTime;
      currentAngle += angleAcceleration * deltaTime;

      y += gravity * deltaTime;
      angle = currentAngle;

      if (currentAngle > 1.5) currentAngle = 1.5;

      if (y > gameRef.size.y - 160 - (spriteSize.y / 2)) {
        y = gameRef.size.y - 160 - (spriteSize.y / 2);
        gameOver();
      }
      if (y < (spriteSize.y / 2)) {
        y = (spriteSize.y / 2);
        gameOver();
      }
    }

    if (!mainGameProvider.gameOver) player?.update(dt);
  }

  void gameOver() {
    if (mainGameProvider.gameOver) return;
    sfxProvider.playHitSfx();
    game.camera.shake(intensity: 2);
    mainGameProvider.gameOver = true;
  }

  @override
  void render(Canvas canvas) {
    player?.render(canvas);
  }
}
