import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/overlays/overlay_scrim.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PauseMenuOverlay extends StatefulWidget {
  final Game game;
  const PauseMenuOverlay({
    required this.game,
    super.key});

  @override
  State<PauseMenuOverlay> createState() => _PauseMenuOverlayState();
}

class _PauseMenuOverlayState extends State<PauseMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: OverlayScrim(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Paused',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    GestureDetector(
                      onTap: (){
                        (widget.game as Breakout).resume();
                      },
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}