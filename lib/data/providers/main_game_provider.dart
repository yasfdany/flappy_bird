import 'package:flutter/painting.dart';

class MainGameProvider {
  VoidCallback? onGetScore;
  bool startGame = false;
  bool gameOver = false;
  double pipeSpace = 0;
  double pipeGap = 0;
  int score = 0;

  void resetState() {
    score = 0;
    startGame = false;
    gameOver = false;
  }
}
