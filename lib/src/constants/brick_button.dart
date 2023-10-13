import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BouncyButton extends StatefulWidget {
  final String text;
  final bool isTapped;
  final void Function() onTap;

  const BouncyButton({super.key,
    required this.text,
    required this.isTapped,
    required this.onTap,
  });

  @override
  _BouncyButtonState createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _controller.forward().then((value) {
          _controller.reverse();
          widget.onTap();
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (0.1 * _controller.value),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/menu-Tiles.png', width: 170),
                Text(
                  widget.text,
                  style: GoogleFonts.pressStart2p(color: Colors.yellowAccent, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
