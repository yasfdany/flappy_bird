import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/components/background.dart';
import 'package:flappy_bird/components/hero.dart';

import '../../components/road.dart';
import '../../data/providers/main_game_provider.dart';
import '../../main.dart';

class MainGameScene extends FlameGame with HasTappables {
  final mainGameProvider = getIt.get<MainGameProvider>();
  final hero = Hero();

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    if (mainGameProvider.gameOver) {
      hero.resetState();
      mainGameProvider.startGame = false;
      mainGameProvider.gameOver = false;
    } else {
      hero.flap();
    }
  }

  @override
  Future<void> onLoad() async {
    add(Background());
    add(Road());
    add(Road(position: Vector2(size.x, 0)));
    add(hero);
  }
}
