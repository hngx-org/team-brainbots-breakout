import 'package:brainbots_breakout/src/config/router_config.dart';
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
            width: MediaQuery.of(context).size.width - 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/window.png',),
                Align(
                    alignment: const Alignment(0, -0.13),
                    child: Text('Paused',style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 22),)),
                Align(
                  alignment: const Alignment(0, 0.06),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/repeat.png', width: 50,),
                        GestureDetector(
                          onTap: () => routerConfig.pop(),
                            child: Image.asset('assets/images/play.png', width: 95)),
                        Image.asset('assets/images/levels.png', width: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}