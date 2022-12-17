import 'package:flame/components.dart';
import 'package:flappy_bird/r.dart';
import 'package:flappy_bird/utills/extensions.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';

class GetReadyImage extends SpriteComponent with HasGameRef {
  final mainGameProvider = getIt.get<MainGameProvider>();

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load(
      AssetImages.message.fileName,
    );
    size = (sprite?.originalSize ?? Vector2(0, 0)) * 1.4;
    anchor = Anchor.center;
    position = Vector2(gameRef.size.x / 2, gameRef.size.y / 3);
  }

  void resetState() {
    opacity = 1;
  }

  @override
  void update(double dt) {
    if (mainGameProvider.startGame) {
      if (opacity >= 5 * dt) {
        opacity -= 5 * dt;
      } else {
        opacity = 0;
      }
    }
    super.update(dt);
  }
}
