import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FlameGame game;
  late GameManager gameManager;
  late LevelManager levelManager;

  @override
  void initState(){
    super.initState();
    gameManager = GameManager();
    levelManager = LevelManager();
    game = Breakout(
      gameManager: gameManager,
      levelManager: levelManager
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GameWidget(
          game: game,
         // TODO: add overlay maps
        ),
      ),
    );
  }
}