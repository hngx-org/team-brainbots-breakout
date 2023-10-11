import 'dart:async';

import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      startImageSwitchTimer();
    });
  }

  void startImageSwitchTimer() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      routerConfig.push(RoutesPath.menuScreen);
      timer.cancel();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 5.0,
                    left: 0.0,
                    child: Text('Breakout',
                        style: GoogleFonts.pressStart2p(
                            color: Colors.orange,
                            fontSize: 35,
                            fontWeight: FontWeight.bold)),
                  ),
                  Text('Breakout',
                      style: GoogleFonts.pressStart2p(
                          color: Colors.yellowAccent,
                          fontSize: 35,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.centerRight,
              child: Text('By BrainBots',
                  style: GoogleFonts.pressStart2p(
                      color: Colors.yellowAccent.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
