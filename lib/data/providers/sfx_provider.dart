import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/utills/extensions.dart';

import '../../r.dart';

class SfxProvider {
  AudioPool? hitSfx;
  AudioPool? wingSfx;

  double volume = 0.4;

  SfxProvider() {
    loadAssets();
  }

  void loadAssets() async {
    hitSfx = await FlameAudio.createPool(
      AssetAudio.hit.fileName,
      minPlayers: 3,
      maxPlayers: 4,
    );
    wingSfx = await FlameAudio.createPool(
      AssetAudio.wing.fileName,
      minPlayers: 3,
      maxPlayers: 4,
    );
  }

  void playHitSfx() {
    hitSfx?.start(volume: volume);
  }

  void playWingSfx() {
    wingSfx?.start(volume: volume);
  }
}
