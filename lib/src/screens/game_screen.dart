import 'package:brainbots_breakout/src/data/user_model.dart';
import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:brainbots_breakout/src/game/overlays/game_over_overlay.dart';
import 'package:brainbots_breakout/src/game/overlays/game_overlay.dart';
import 'package:brainbots_breakout/src/game/overlays/intro_overlay.dart';
import 'package:brainbots_breakout/src/game/overlays/pause_menu_overlay.dart';
import 'package:brainbots_breakout/src/game/overlays/win_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final int level;
  final UserModel user;
  
  const GameScreen({
    this.level = 1,
    required this.user,
    super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FlameGame game;
  late GameManager gameManager;
  late LevelManager levelManager;
  bool isVisible = false;

  @override
  void initState(){
    super.initState();
    gameManager = GameManager();
    levelManager = LevelManager(level: widget.level);
    game = Breakout(
      gameManager: gameManager,
      levelManager: levelManager,
      user: widget.user
    );
    Future.delayed(
      const Duration(milliseconds: 200),
      (){
        setState(() {
          isVisible = true;
        });
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible? 1: 0,
      duration: const Duration(milliseconds: 200),
      child: Center(
        child: GameWidget(
          game: game,
          overlayBuilderMap: <String, Widget Function(BuildContext, FlameGame)>{
            'gameOverlay': (context, game) => GameOverlay(game: game,),
            'pauseMenuOverlay': (context, game) => PauseMenuOverlay(game: game),
            'introOverlay': (context, game) => IntroOverlay(game: game),
            'gameOverOverlay': (context, game) => GameOverOverlay(game: game),
            'winOverlay': (context, game) => WinOverlay(game: game),
          },
        ),
      ),
    );
  }
}