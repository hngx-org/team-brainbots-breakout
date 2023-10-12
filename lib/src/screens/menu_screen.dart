
import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/background.dart';
import 'package:brainbots_breakout/src/constants/brick_button.dart';
import 'package:brainbots_breakout/src/constants/loading_widget.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>{
  bool isPlayTapped = false;
  bool isLevelTapped = false;
  bool isSettingsTapped = false;
  bool isHowTapped = false;
  bool areButtonsVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        areButtonsVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
              opacity: areButtonsVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              child: CustomBackground(mediaQuery: mediaQuery)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: areButtonsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'BREAKOUT',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.orange.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Positioned(
                      top: 5.0,
                      left: 0.0,
                      child: Text(
                        'BREAKOUT',
                        style: GoogleFonts.pressStart2p(
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              40.verticalSpace,
                AnimatedOpacity(
                  opacity: areButtonsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                  child: BouncyButton(
                    text: 'Play',
                    onTap: () {
                      setState(() {
                        isPlayTapped = !isPlayTapped;
                      });
                      routerConfig.pushReplacement(RoutesPath.gameScreen);
                    },
                    isTapped: isPlayTapped,
                  ),
                ),
              20.verticalSpace,
              AnimatedOpacity(
                opacity: areButtonsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeIn,
                child: BouncyButton(
                  text: 'Levels',
                  onTap: () {
                    setState(() {
                      isLevelTapped = !isLevelTapped;
                    });
                    routerConfig.push(RoutesPath.levelScreen);
                  },
                  isTapped: isLevelTapped,
                ),
              ),
              20.verticalSpace,
              AnimatedOpacity(
                opacity: areButtonsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeIn,
                child: BouncyButton(
                  text: 'Settings',
                  onTap: () {
                    setState(() {
                      isSettingsTapped = !isSettingsTapped;
                    });
                  },
                  isTapped: isSettingsTapped,
                ),
              ),
              20.verticalSpace,
              AnimatedOpacity(
                opacity: areButtonsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: BouncyButton(
                  text: 'Exit',
                  onTap: () {
                    setState(() {
                      isHowTapped = !isHowTapped;
                    });
                    // Add code for the 'How to play' button action here.
                  },
                  isTapped: isHowTapped,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}