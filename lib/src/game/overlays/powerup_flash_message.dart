import 'package:brainbots_breakout/src/constants/color.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PowerUpFlashMessage extends StatefulWidget {
  final Game game;
  final String flashMessage;
  const PowerUpFlashMessage({super.key, required this.game, required this.flashMessage, });

  @override
  State<PowerUpFlashMessage> createState() => _PowerUpFlashMessageState();
}

class _PowerUpFlashMessageState extends State<PowerUpFlashMessage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 22,
                child: Text(widget.flashMessage,
                  style: GoogleFonts.pressStart2p(
                      fontSize: 12, color: Colors.white.withOpacity(0.4), decoration: TextDecoration.none
                  ),
                  textAlign: TextAlign.center, ),
              ),
              Text(widget.flashMessage,
                style: GoogleFonts.pressStart2p(
                fontSize: 12, color: MyColor.appColor.withOpacity(0.4), decoration: TextDecoration.none
              ),
                textAlign: TextAlign.center, ),
            ],
          ),
        ),
      ),
    );
  }
}
