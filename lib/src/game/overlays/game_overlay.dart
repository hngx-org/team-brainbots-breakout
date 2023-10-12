import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverlay extends StatefulWidget {

  final FlameGame game;

  const GameOverlay({
    required this.game,
    super.key});

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.9),
      child: SizedBox(
        height: 40,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                child: DisplayScore(game: widget.game,)
              ),
              Positioned(
                right: 10,
                child: PauseButton(game: widget.game)
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayScore extends StatefulWidget {
  final FlameGame game;
  const DisplayScore({
    required this.game,
    super.key});

  @override
  State<DisplayScore> createState() => _DisplayScoreState();
}

class _DisplayScoreState extends State<DisplayScore> {
  
  @override
  void initState(){
    super.initState();
    (widget.game as Breakout).gameManager.score
      .addListener(() {
        setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) {
    return Text(
      'SCORE:${(widget.game as Breakout).gameManager.score.value}',
      style: GoogleFonts.pressStart2p(
        color: Colors.white.withOpacity(0.8),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}

class PauseButton extends StatelessWidget {
  final FlameGame game;
  const PauseButton({
    required this.game,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        (game as Breakout).pause();
      },
      child: const Icon(
        Icons.pause,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
                          