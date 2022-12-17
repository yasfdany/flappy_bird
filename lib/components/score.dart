import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../data/providers/main_game_provider.dart';
import '../main.dart';

class Score extends PositionComponent with HasGameRef {
  final mainGameProvider = getIt.get<MainGameProvider>();
  final numbers = <Sprite>[];

  Future generateNumbers() async {
    numbers.clear();
    final numbersItem = mainGameProvider.score.toString().split("");
    for (String number in numbersItem) {
      final sprite = await Sprite.load(
        "num-$number.png",
      );
      numbers.add(sprite);
    }
    position = Vector2(
      gameRef.size.x / 2 -
          ((numbers.length * ((numbers.first.srcSize.x) + 1)) / 2),
      20,
    );
  }

  @override
  Future<void>? onLoad() async {
    await generateNumbers();
    mainGameProvider.onGetScore = () => generateNumbers();
  }

  @override
  void render(Canvas canvas) {
    for (int i = 0; i < numbers.length; i++) {
      numbers[i].render(
        canvas,
        position: Vector2(i * ((numbers[i].srcSize.x) + 1), y),
      );
    }
  }
}
