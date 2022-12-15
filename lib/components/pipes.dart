import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_bird/components/point_area.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';
import 'pipe.dart';

class Pipes extends PositionComponent with HasGameRef {
  final mainGameProvider = getIt.get<MainGameProvider>();
  final random = Random();
  final steps = [-100, -50, 0, 50, 100];

  Vector2? initialPosition;
  double offset = 0;

  Pipes({this.initialPosition});

  void resetState() {
    position = initialPosition ?? Vector2(gameRef.size.x, 0);
  }

  @override
  Future<void>? onLoad() async {
    mainGameProvider.pipeSpace = gameRef.size.y / 4;
    position = initialPosition ?? Vector2(gameRef.size.x, 0);
    size = Vector2(96, gameRef.size.y - 160);

    final pipeUpPos = Vector2(0, (-mainGameProvider.pipeSpace / 2) + offset);
    final pipeDownPos = Vector2(
      0,
      gameRef.size.y / 1.8 + offset + (mainGameProvider.pipeSpace / 2),
    );

    add(Pipe(
      type: PipeType.up,
      position: pipeUpPos,
    ));
    add(
      Pipe(
        type: PipeType.down,
        position: pipeDownPos,
      ),
    );
    add(PointArea(
      position: Vector2(
        0,
        (gameRef.size.y / 1.8) + (-mainGameProvider.pipeSpace / 2) + offset,
      ),
    ));
  }

  @override
  void update(double dt) {
    if (!mainGameProvider.startGame || mainGameProvider.gameOver) return;
    y = -160 + offset;
    x -= 180 * dt;
    if (x < -size.x) {
      x = gameRef.size.x + mainGameProvider.pipeGap;
      offset = steps[random.nextInt(steps.length)].toDouble();
    }
  }
}
