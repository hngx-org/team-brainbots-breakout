import 'package:flutter/material.dart';

class OverlayScrim extends StatelessWidget {
  final Widget child;

  const OverlayScrim({
    required this.child,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.32,
          child: Container(
            color: Colors.white,
          ),
        ),
        Center(child: child)
      ],
    );
  }
}