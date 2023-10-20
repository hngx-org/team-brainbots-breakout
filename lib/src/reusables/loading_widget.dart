import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: MediaQuery.of(context).size.width / 1.3,
      animation: true,
      lineHeight: 20.0,
      alignment: MainAxisAlignment.center,
      animationDuration: 2000,
      percent: 0.9,
      center: Text('loading...', style: GoogleFonts.pressStart2p(
          color: Colors.black, fontSize: 12),),
      barRadius: const Radius.circular(10),
      progressColor: Colors.yellowAccent,
    );
  }
}