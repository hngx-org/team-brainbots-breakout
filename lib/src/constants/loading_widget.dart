import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width - 50,
        animation: true,
        lineHeight: 20.0,
        animationDuration: 2000,
        percent: 0.9,
        center: const Text("90.0%"),
        barRadius: const Radius.circular(10),
        progressColor: Colors.yellowAccent,
      ),
    );
  }
}