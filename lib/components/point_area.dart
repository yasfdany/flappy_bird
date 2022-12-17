import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/data/providers/sfx_provider.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';
import 'bird.dart';

class PointArea extends PositionComponent with CollisionCallbacks {
  final mainGameProvider = getIt.get<MainGameProvider>();
  final sfxProvider = getIt.get<SfxProvider>();
  bool getPoint = false;

  PointArea({super.position});

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (mainGameProvider.gameOver) return;
    if (other is Bird) {
      if (!getPoint) {
        sfxProvider.playPointSfx();
        getPoint = true;
        mainGameProvider.score++;
        mainGameProvider.onGetScore?.call();
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    Future.delayed(const Duration(milliseconds: 500), () {
      getPoint = false;
    });
    super.onCollisionEnd(other);
  }

  @override
  Future<void>? onLoad() async {
    size = Vector2(96, mainGameProvider.pipeSpace);
    final hitBox = RectangleHitbox(
      size: Vector2(1, size.y - 10),
      position: Vector2((size.x - 1) / 2, 5),
    );
    add(hitBox);
  }
}
