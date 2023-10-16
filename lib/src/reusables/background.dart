import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({
    super.key,
    required this.mediaQuery,
  });

  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: mediaQuery.width,
          height: mediaQuery.height,
          child: Image.asset('assets/images/others/stars_background.png', fit: BoxFit.cover,),
        ),
      ],
    );
  }
}