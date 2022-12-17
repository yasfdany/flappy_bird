import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/components/background.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/get_ready_image.dart';
import 'package:flappy_bird/components/pipes.dart';
import 'package:flappy_bird/components/score.dart';
import 'package:flutter/foundation.dart';

import '../../components/road.dart';
import '../../data/providers/main_game_provider.dart';
import '../../main.dart';

class MainGameScene extends FlameGame
    with HasGameRef, HasTappables, HasCollisionDetection {
  final mainGameProvider = getIt.get<MainGameProvider>();
  final score = Score();
  final getReadyImage = GetReadyImage();
  final hero = Bird();
  final pipes = [];

  @override
  Future<void> onLoad() async {
    mainGameProvider.pipeGap = gameRef.size.x / 1.8;
    for (int i = 0; i < 3; i++) {
      pipes.add(Pipes(
        initialPosition: Vector2(
          gameRef.size.x + (i * mainGameProvider.pipeGap),
          0,
        ),
      ));
    }
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
    for (Pipes pipe in pipes) {
      add(pipe);
    }
    add(Road(initialPosition: Vector2(0, 0)));
    add(Road(initialPosition: Vector2(size.x, 0)));
    add(hero);
    add(getReadyImage);
    add(score);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    if (mainGameProvider.gameOver) {
      for (Pipes pipe in pipes) {
        pipe.resetState();
        getReadyImage.resetState();
      }
      hero.resetState();
      mainGameProvider.resetState();
      score.generateNumbers();
    } else {
      hero.flap();
    }
  }
}
