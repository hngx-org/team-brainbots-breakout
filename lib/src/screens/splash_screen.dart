import 'dart:async';

import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/reusables/loading_widget.dart';
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
      _preloadAssets();
      routerConfig.pushReplacement(RoutesPath.menuScreen);
      timer.cancel();
    });
  }

  Future<void> _preloadAssets() async {
    await Future.wait([
      // Flame.images.loadAllImages(),
      precacheImage(const AssetImage('assets/images/others/stars_background.png'), context),
      precacheImage(const AssetImage('assets/images/others/menu_tile.png'), context),
      precacheImage(const AssetImage('assets/images/others/menu_tile_cracked.png'), context),
      precacheImage(const AssetImage('assets/images/others/level_card_selected.png'), context),
      precacheImage(const AssetImage('assets/images/others/level_card.png'), context),
      precacheImage(const AssetImage('assets/images/others/sound_off.png'), context),
      precacheImage(const AssetImage('assets/images/others/sound_on.png'), context),
      precacheImage(const AssetImage('assets/images/others/button_tile.png'), context),
      precacheImage(const AssetImage('assets/images/others/button_tile_selected.png'), context),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
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
            10.verticalSpace,
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: Text('By BrainBots',
                    style: GoogleFonts.pressStart2p(
                        color: Colors.yellowAccent.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            40.verticalSpace,
            const LoadingWidget(),
          ],
        ),
      ),
    );
  }
}