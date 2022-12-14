import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/components/background.dart';
import 'package:flappy_bird/components/hero.dart';
import 'package:flappy_bird/components/pipes.dart';
import 'package:flutter/foundation.dart';

import '../../components/road.dart';
import '../../data/providers/main_game_provider.dart';
import '../../main.dart';

class MainGameScene extends FlameGame
    with HasGameRef, HasTappables, HasCollisionDetection {
  final mainGameProvider = getIt.get<MainGameProvider>();
  final hero = Hero();
  final pipes = [
    Pipe(),
  ];

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    if (mainGameProvider.gameOver) {
      for (Pipe pipe in pipes) {
        pipe.resetState();
      }
      hero.resetState();
      mainGameProvider.startGame = false;
      mainGameProvider.gameOver = false;
    } else {
      hero.flap();
    }
  }

  @override
  Future<void> onLoad() async {
    if (kIsWeb) {
      if (gameRef.size.x > gameRef.size.y) {
        camera.viewport = FixedResolutionViewport(
          Vector2(gameRef.size.x / 4, gameRef.size.y),
        );
      } else {
        camera.viewport = FixedResolutionViewport(
          Vector2(500, gameRef.size.y),
        );
      }
    }

    add(Background());
    for (Pipe pipe in pipes) {
      add(pipe);
    }
    add(Road());
    add(Road(position: Vector2(size.x, 0)));
    add(hero);
  }
}
