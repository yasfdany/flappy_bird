import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/utills/extensions.dart';
import 'package:flutter/material.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';
import '../r.dart';

class Road extends PositionComponent with HasGameRef {
  final mainGameProvider = getIt.get<MainGameProvider>();
  Sprite? roadSprite;
  double speed = 3;

  Road({super.position});

  @override
  void update(double dt) {
    y = gameRef.size.y - 160;
    if (mainGameProvider.gameOver) return;

    x -= speed;
    if (x < -gameRef.size.x + speed) x = gameRef.size.x;
  }

  @override
  Future<void>? onLoad() async {
    x = position.x;
    size = Vector2(
      gameRef.size.x,
      160,
    );

    final road = await Flame.images.load(AssetImages.base.fileName);
    roadSprite = Sprite(
      road,
    );
  }

  @override
  void render(Canvas canvas) {
    roadSprite?.render(
      canvas,
      anchor: Anchor.topLeft,
      size: Vector2(
        gameRef.size.x,
        160,
      ),
    );
  }
}
