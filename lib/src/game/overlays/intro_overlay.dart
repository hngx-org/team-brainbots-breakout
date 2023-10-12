import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/overlays/overlay_scrim.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroOverlay extends StatefulWidget {

  final FlameGame game;
  const IntroOverlay({
    required this.game,
    super.key});

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: GestureDetector(
          onTap: (){
            (widget.game as Breakout).start();
          },
          child: OverlayScrim(
            child: Text(
              'Tap to start',
              style: GoogleFonts.pressStart2p(
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        )
      )
    );
  }
}
