import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/data/providers/main_game_provider.dart';
import 'package:flappy_bird/data/providers/sfx_provider.dart';
import 'package:flappy_bird/scenes/main_game/main_game_scene.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<MainGameProvider>(MainGameProvider());
  getIt.registerSingleton<SfxProvider>(SfxProvider());

  runApp(GameWidget(game: MainGameScene()));
  Flame.device.fullScreen();
  Flame.device.setPortrait();
}
