import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/utills/extensions.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';
import '../r.dart';

enum PipeType {
  up,
  down,
}

class Pipe extends PositionComponent with HasGameRef {
  final mainGameProvider = getIt.get<MainGameProvider>();
  SpriteComponent? pipe;
  late PipeType type;

  Pipe({required this.type, super.position});

  @override
  Future<void>? onLoad() async {
    size = Vector2(96, gameRef.size.y / 1.8);
    switch (type) {
      case PipeType.up:
        pipe = SpriteComponent.fromImage(
          await Flame.images.load(AssetImages.pipeGreen.fileName),
          size: size,
        );
        pipe?.flipVerticallyAroundCenter();
        break;
      case PipeType.down:
        pipe = SpriteComponent.fromImage(
          await Flame.images.load(AssetImages.pipeGreen.fileName),
          size: size,
        );
        break;
    }

    add(pipe!);
    add(RectangleHitbox());
  }
}
