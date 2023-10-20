import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:brainbots_breakout/src/game/overlays/game_over_overlay.dart';
import 'package:brainbots_breakout/src/game/overlays/game_overlay.dart';
import 'package:brainbots_breakout/src/game/overlays/intro_overlay.dart';
import 'package:brainbots_breakout/src/game/overlays/pause_menu_overlay.dart';
import 'package:brainbots_breakout/src/game/overlays/powerup_flash_message.dart';
import 'package:brainbots_breakout/src/game/overlays/win_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final int level;
  
  const GameScreen({
    this.level = 1,
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
            'extraBallOverlay': (context, game) => PowerUpFlashMessage(game: game, flashMessage: 'Extra ball!',),
            'slowBallOverlay': (context, game) => PowerUpFlashMessage(game: game, flashMessage: 'Slow ball!',),
            'fastBallOverlay': (context, game) => PowerUpFlashMessage(game: game, flashMessage: 'Fast ball!',),
            'shrinkPaddleOverlay': (context, game) => PowerUpFlashMessage(game: game, flashMessage: 'Paddle shrunk!',),
            'enlargedPaddleOverlay': (context, game) => PowerUpFlashMessage(game: game, flashMessage: 'Paddle enlarged!',),
            'magneticPaddleOverlay': (context, game) => PowerUpFlashMessage(game: game, flashMessage: 'Magnetic Paddle!',),
            'laserPaddleOverlay': (context, game) => PowerUpFlashMessage(game: game, flashMessage: 'Laser Paddle!',),
          },
        ),
      ),
    );
  }
}