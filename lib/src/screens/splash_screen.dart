import 'dart:async';

import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  int imageIndex = 0;
  late AnimationController animationController;
  List<String> imagePaths = [
    'assets/images/Background@3x.png',
    'assets/images/Example@3x.png',
    'assets/images/Line@3x.png',
  ];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    Future.delayed(const Duration(seconds: 3), () {
      startImageSwitchTimer();
    });
  }

  void startImageSwitchTimer() {

    Timer.periodic(const Duration(seconds: 2), (timer) {
      routerConfig.push(RoutesPath.menuScreen);
      timer.cancel();
      // if (imageIndex < imagePaths.length - 1) {
      //   setState(() {
      //     imageIndex++;
      //     animationController.reset();
      //     animationController.forward();
      //   });
      // }
      // else {
      //   timer.cancel();
      //   // Navigate to the next screen
      //   routerConfig.push(RoutesPath.menuScreen);
      // }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'BrainBots Breakout',
                  style: GoogleFonts.pressStart2p(color: Colors.orangeAccent)
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // FadeTransition(
            //     opacity: animationController,
            // child: Image.asset(imagePaths[imageIndex])),
          ],
        ),
      ),
    );
  }
}
