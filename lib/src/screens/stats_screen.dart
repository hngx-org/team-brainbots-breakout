import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:brainbots_breakout/src/reusables/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with TickerProviderStateMixin{
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
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
            opacity: areButtonsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            child: CustomBackground(mediaQuery: mediaQuery)),
        AnimatedOpacity(
          opacity: areButtonsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: mediaQuery.height,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'STATS',
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
                        'STATS',
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
                40.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Games Played',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: -2.5,
                          wordSpacing: -1
                      ),
                      textAlign: TextAlign.center,
                    ),
                    20.verticalSpace,
                    Text(
                      '${userConfig.noGamesPlayed.value}',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                40.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Game Time',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: -2.5,
                        wordSpacing: -1
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${userConfig.totalGameTime.value.inMinutes} ${userConfig.totalGameTime.value.inMinutes > 1 ? 'mins': 'min'}',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                20.verticalSpace,
                GestureDetector(
                  onTap: () {
                    routerConfig.push(RoutesPath.menuScreen);
                  },
                  child: SizedBox(
                    height: 80,
                    child: Stack(
                      children: [
                        Align(
                          alignment: const Alignment(0, 0),
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.yellowAccent
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, 0.2),
                          child: Container(
                            height: 40,
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.orange
                            ),
                            child: Text(
                              'Ok',
                              style: GoogleFonts.pressStart2p(
                                  color: Colors.yellowAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  wordSpacing: -1
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
              ),
        )],

    );
  }
}
