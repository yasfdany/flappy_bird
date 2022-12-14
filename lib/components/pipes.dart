import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/r.dart';
import 'package:flappy_bird/utills/extensions.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';

class Pipe extends PositionComponent with HasGameRef {
  final mainGameProvider = getIt.get<MainGameProvider>();
  SpriteComponent? pipeUp;
  SpriteComponent? pipeDown;
  Vector2? initialPosition;
  late double gap;

  Pipe({this.initialPosition});

  void resetState() {
    position = initialPosition ?? Vector2(gameRef.size.x, 0);
  }

  @override
  Future<void>? onLoad() async {
    position = initialPosition ?? Vector2(gameRef.size.x, 0);
    gap = gameRef.size.y / 4;
    size = Vector2(96, (gameRef.size.y / 2) - 80);
    pipeUp = SpriteComponent.fromImage(
      await Flame.images.load(AssetImages.pipeGreen.fileName),
      position: Vector2(0, -(gap / 2)),
      size: size,
    );
    pipeDown = SpriteComponent.fromImage(
      await Flame.images.load(AssetImages.pipeGreen.fileName),
      position: Vector2(0, gameRef.size.y - 160 + (gap / 2)),
      anchor: Anchor.bottomLeft,
      size: size,
    );

    pipeUp?.flipVerticallyAroundCenter();

    add(pipeUp!);
    add(pipeDown!);
  }

  @override
  void update(double dt) {
    if (!mainGameProvider.startGame || mainGameProvider.gameOver) return;
    x -= 180 * dt;
    if (x < -size.x) x = gameRef.size.x;
  }
}
