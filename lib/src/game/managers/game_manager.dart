import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

enum GameState {intro, playing, paused, gameOver, win}

class GameManager extends Component with HasGameRef<Breakout>{
  ValueNotifier<int> score = ValueNotifier(0);
  GameState state = GameState.intro;
  bool get isIntro => state == GameState.intro;
  bool get isPlaying => state == GameState.playing;
  bool get isPaused => state == GameState.paused;
  bool get isGameOver => state == GameState.gameOver;
  bool get isWin => state == GameState.win;

  void reset(){
    state = GameState.intro;
    score.value = 0;
  }
}