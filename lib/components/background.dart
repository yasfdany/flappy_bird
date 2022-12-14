import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flappy_bird/utills/extensions.dart';

import '../r.dart';

class Background extends Component with HasGameRef {
  Sprite? backgroundSprite;

  @override
  Future<void>? onLoad() async {
    backgroundSprite = await Sprite.load(AssetImages.backgroundDay.fileName);
  }

  @override
  void render(Canvas canvas) {
    backgroundSprite?.render(
      canvas,
      size: gameRef.size,
    );
  }
}
