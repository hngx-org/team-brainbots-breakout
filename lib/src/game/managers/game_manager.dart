import 'dart:math';

import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/sprites/power_up.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

enum GameState {intro, playing, paused, gameOver, win}

class GameManager extends Component with HasGameRef<Breakout>{
  ValueNotifier<int> score = ValueNotifier(0);
  int noBricks = 0;
  GameState state = GameState.intro;
  bool get isIntro => state == GameState.intro;
  bool get isPlaying => state == GameState.playing;
  bool get isPaused => state == GameState.paused;
  bool get isGameOver => state == GameState.gameOver;
  bool get isWin => state == GameState.win;
  Stopwatch gameStopwatch = Stopwatch();
  void reset(){
    state = GameState.intro;
    score.value = 0;
    gameStopwatch.reset();
  }
  PowerUpType getRandomPowerUpType(int level) {
    final random = Random();
    List<PowerUpType> powerUps;

    if (level % 2 == 0) {
      powerUps = [PowerUpType.fast, PowerUpType.enlarge];
      if (random.nextDouble() < 0.4) {
        powerUps.add(PowerUpType.laser); // 20% chance for laser
      }
      if (random.nextDouble() < 0.4) {
        powerUps.add(PowerUpType.extraBall); // 20% chance for extraBall
      }
    } else {
      powerUps = [PowerUpType.slow, PowerUpType.shrink];
      if (random.nextDouble() < 0.4) {
        powerUps.add(PowerUpType.laser);
      }
      if (random.nextDouble() < 0.4) {
        powerUps.add(PowerUpType.extraBall);
      }
    }

    return powerUps[random.nextInt(powerUps.length)];
  }


  List<List<int>> basePattern = [
    [1, 0, 0, 1, 0, 0, 1],
    [0, 0, 1, 1, 1, 0, 0],
    [1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1],
    [1, 1, 0, 1, 0, 1, 1],
    [0, 1, 0, 0, 0, 1, 0],
    [1, 1, 0, 1, 0, 1, 0],
  ];

  List<List<int>> basePattern2 = [
    [1, 1, 0, 0, 0, 1, 1],
    [0, 0, 1, 0, 1, 0, 0],
    [1, 1, 0, 0, 0, 1, 1],
    [1, 0, 1, 1, 1, 0, 1],
    [1, 1, 0, 0, 0, 1, 1],
    [0, 1, 1, 0, 1, 1, 0],
    [1, 0, 1, 1, 1, 0, 1],
  ];

  List<int> patternCounts = [49, 50, 60, 70, 80, 90, 100, 110, 120];

  List<List<List<int>>?> patternsByLevel = [];

  List<List<List<int>>?> generatePatternsByLevel() {
    final random = Random();
    for (int level = 1; level <= 9; level++) {
      List<List<int>> patterns = [];
      int totalPatterns = patternCounts[level - 1];

      List<List<int>> selectedBasePattern = random.nextInt(2) == 0
          ? basePattern
          : basePattern2;

      for (int i = 0; i < totalPatterns; i++) {
        patterns.add(selectedBasePattern[i % selectedBasePattern.length]);
      }

      patternsByLevel.add(patterns);
    }
    return patternsByLevel;
  }

  List<List<int>> generateRandomPattern(int patternCount) {
    // Base pattern
    List<List<int>> basePattern = [
      [1, 0, 0, 1, 0, 0, 1],
      [0, 0, 1, 1, 1, 0, 0],
      [1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 0, 1],
      [1, 1, 0, 1, 0, 1, 1],
      [0, 1, 0, 0, 0, 1, 0],
      [1, 1, 0, 1, 0, 1, 0],
    ];

    // Calculate the number of rows to add based on the level
    int numRowsToAdd = patternCount - 1;

    // Create the pattern by repeating the base pattern with additional rows
    List<List<int>> generatedPattern = [];
    for (int i = 0; i < basePattern.length + numRowsToAdd; i++) {
      // If it's within the base pattern rows, add the base row
      if (i < basePattern.length) {
        generatedPattern.add(List<int>.from(basePattern[i]));
      } else {
        // If it's beyond the base pattern rows, add a new row with alternating values
        generatedPattern.add(List<int>.generate(7, (index) => index % 2));
      }
    }

    return generatedPattern;
  }


  // String formatTime(int seconds){
  //   int totalSeconds = time.value;
  //   int minutes = totalSeconds ~/ 60; // Integer division to get minutes
  //   int seconds = totalSeconds % 60; // Modulo operation to get remaining seconds

  //   String minutesText = minutes == 1 ? 'min' : 'mins';

  //   String timeInMinutesAndSeconds = '$minutes:${seconds.toString().padLeft(2, '0')} $minutesText';
  //   return timeInMinutesAndSeconds;
  // }
}
