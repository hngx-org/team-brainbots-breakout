import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/color.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/overlays/overlay_scrim.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PauseMenuOverlay extends StatefulWidget {
  final Game game;
  const PauseMenuOverlay({required this.game, super.key});

  @override
  State<PauseMenuOverlay> createState() => _PauseMenuOverlayState();
}

class _PauseMenuOverlayState extends State<PauseMenuOverlay>
    with TickerProviderStateMixin{
  late AnimationController _playController;
  late AnimationController _levelController;
  late AnimationController _resetController;
  int time = 0;
  String formattedTime = '';

  @override
  void initState() {
    super.initState();
    _playController = AnimationController(
      vsync: this,
      duration:
      const Duration(milliseconds: 200),
    );
    _resetController = AnimationController(
      vsync: this,
      duration:
      const Duration(milliseconds: 200),
    );
    _levelController = AnimationController(
      vsync: this,
      duration:
      const Duration(milliseconds: 200),
    );

    time = (widget.game as Breakout).gameManager.gameStopwatch.elapsed.inSeconds;
    // formattedTime = (widget.game as Breakout).gameManager.formatTime(time);
  }

  @override
  void dispose() {
    _playController.dispose();
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
                Align(
                    alignment: const Alignment(0, -0.215),
                    child: Text(
                      'TIME:${time}s',
                      style: GoogleFonts.pressStart2p(
                          color: MyColor.appColor, fontSize: 22),
                    )),
                Image.asset(
                  'assets/images/others/window.png',
                ),
                Align(
                    alignment: const Alignment(0, -0.115),
                    child: Text(
                      'Paused',
                      style: GoogleFonts.pressStart2p(
                          color: MyColor.appColor, fontSize: 22),
                    )),
                Align(
                    alignment: const Alignment(0, -0.11),
                    child: Text(
                      'Paused',
                      style: GoogleFonts.pressStart2p(
                          color: MyColor.secondaryColor, fontSize: 22),
                    )),
                Align(
                  alignment: const Alignment(0, 0.06),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _resetController.forward().then((value) {
                              _resetController.reverse().then((_){
                                (widget.game as Breakout).reset();
                              });
                            });
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
                              }
                            )),
                        GestureDetector(
                            onTap: () {
                              _playController.forward().then((value) {
                                _playController.reverse();
                                (widget.game as Breakout).resume();
                              });
                              (widget.game as Breakout).resume();
                              },
                            child: AnimatedBuilder(
                                animation: _playController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 - (0.1 * _playController.value),
                                  child: Image.asset('assets/images/others/play.png',
                                      width: 95),
                                );
                              }
                            )),
                        GestureDetector(
                            onTap: () {
                              _levelController.forward().then((value) {
                                _levelController.reverse();
                              });
                                  routerConfig.pushReplacement(RoutesPath.levelScreen);
                                },
                            child: AnimatedBuilder(
                                animation: _levelController,
                                builder: (context, child) {
                                return Transform.scale(
                                    scale: 1.0 - (0.1 * _levelController.value),
                                    child: Image.asset('assets/images/others/levels.png', width: 95));
                              }
                            )),
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
