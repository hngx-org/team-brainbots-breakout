import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BouncyButton extends StatelessWidget {
  final String text;
  final bool isTapped;
  final void Function() onTap;

  BouncyButton({
    required this.text,
    required this.isTapped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.0,
          end: isTapped ? 0.9 : 1.0, // Adjust the scaling values as needed.
        ).animate(
          CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/menu-Tiles.png', width: 170),
            Text(
              text,
              style: GoogleFonts.pressStart2p(color: Colors.yellowAccent, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}