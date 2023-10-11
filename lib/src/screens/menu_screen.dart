
import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isPlayTapped = false;
  bool isSettingsTapped = false;
  bool isHowTapped = false;

  Future<void> _preloadAssets() async {
    await Future.wait([
      precacheImage(const AssetImage('assets/images/Stars Small_2.png'), context),
      precacheImage(const AssetImage('assets/images/menu-Tiles.png'), context),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return FutureBuilder<void>(
        future: _preloadAssets(),
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: mediaQuery.width,
                  height: mediaQuery.height,
                  child: Image.asset('assets/images/Stars Small_2.png', fit: BoxFit.cover,),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'Welcome to Breakout',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.orange.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Positioned(
                          top: 5.0,
                          left: 29.0,
                          child: Text(
                            'Welcome to \nBreakout',
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
                    BouncyButton(
                      text: 'Play',
                      onTap: () {
                        setState(() {
                          isPlayTapped = !isPlayTapped;
                        });
                        routerConfig.pushReplacement(RoutesPath.gameScreen);
                      },
                      isTapped: isPlayTapped,
                    ),
                    20.verticalSpace,
                    BouncyButton(
                      text: 'Settings',
                      onTap: () {
                        setState(() {
                          isSettingsTapped = !isSettingsTapped;
                        });
                        // Add code for the 'Settings' button action here.
                      },
                      isTapped: isSettingsTapped,
                    ),
                    20.verticalSpace,
                    BouncyButton(
                      text: 'How to play',
                      onTap: () {
                        setState(() {
                          isHowTapped = !isHowTapped;
                        });
                        // Add code for the 'How to play' button action here.
                      },
                      isTapped: isHowTapped,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        else {
          // Display a loading indicator or placeholder while assets are loading.
          return Center(
            child: Padding(
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
            ),
          );
        }
      }
    );
  }
}

class BouncyButton extends StatelessWidget {
  final String text;
  final bool isTapped;
  final void Function() onTap;

  BouncyButton({
    required this.text,
    required this.isTapped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.0,
          end: isTapped ? 0.9 : 1.0, // Adjust the scaling values as needed.
        ).animate(
          CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/menu-Tiles.png', width: 170),
            Text(
              text,
              style: GoogleFonts.pressStart2p(color: Colors.yellowAccent, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}