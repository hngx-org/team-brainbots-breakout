import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/color.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/overlays/overlay_scrim.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverOverlay extends StatefulWidget {
  final Game game;
  const GameOverOverlay({required this.game, super.key});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with TickerProviderStateMixin {
  late AnimationController _levelController;
  late AnimationController _resetController;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _levelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _levelController.dispose();
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: OverlayScrim(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/others/window.png',
                ),
                Align(
                    alignment: const Alignment(0, -0.115),
                    child: Text(
                      'Game Over',
                      style: GoogleFonts.pressStart2p(
                          color: MyColor.appColor, fontSize: 22),
                    )),
                Align(
                    alignment: const Alignment(0, -0.11),
                    child: Text(
                      'Game Over',
                      style: GoogleFonts.pressStart2p(
                          color: MyColor.secondaryColor, fontSize: 22),
                    )),
                Align(
                  alignment: const Alignment(0, 0.06),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              _resetController.forward().then((value) {
                                _resetController.reverse();
                              });
                              (widget.game as Breakout).reset();
                            },
                            child: AnimatedBuilder(
                                animation: _resetController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 - (0.1 * _resetController.value),
                                    child: Image.asset(
                                      'assets/images/others/repeat.png',
                                      width: 95,
                                    ),
                                  );
                                })),
                        25.horizontalSpace,
                        GestureDetector(
                            onTap: () {
                              _levelController.forward().then((value) {
                                _levelController.reverse();
                              });
                              routerConfig
                                  .pushReplacement(RoutesPath.levelScreen);
                            },
                            child: AnimatedBuilder(
                                animation: _levelController,
                                builder: (context, child) {
                                  return Transform.scale(
                                      scale:
                                          1.0 - (0.1 * _levelController.value),
                                      child: Image.asset(
                                          'assets/images/others/levels.png',
                                          width: 95));
                                })),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
