import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/background.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:brainbots_breakout/src/data/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen>
    with TickerProviderStateMixin {
  late AnimationController _homeController;
  late AnimationController _soundController;
  late AnimationController _playController;
  late UserModel user;

  bool isSoundOn = false;
  bool areButtonsVisible = false;
  bool isSelected = false;
  bool playSelected = false;
  int selectedTileIndex = 1;
  late List<bool> levelLockStatus;
  // List<bool> levelLockStatus = [
  //   false,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true
  // ];

  @override
  void initState() {
    super.initState();
    user = UserModel();
    levelLockStatus = List.generate(
      9,
      (index) => index + 1 > user.levelsUnlocked.value);
    _homeController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 200),
    );
    _soundController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 200),
    );
    _playController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 200),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        areButtonsVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return AnimatedOpacity(
      opacity: areButtonsVisible ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomBackground(mediaQuery: mediaQuery),
          Positioned(
              top: mediaQuery.height / 5.5,
              child: Text(
                'LEVELS',
                style: GoogleFonts.pressStart2p(
                    fontSize: 27,
                    color: Colors.orange,
                    decoration: TextDecoration.none),
              )),
          Positioned(
              top: mediaQuery.height / 5.4,
              child: Text(
                'LEVELS',
                style: GoogleFonts.pressStart2p(
                    fontSize: 27,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              )),
          //levels
          Positioned(
            top: mediaQuery.height / 4.8,
            child: SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width, // Adjust the width as needed
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: areButtonsVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 400 * index),
                    curve: Curves.easeIn,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 70.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (columnIndex) {
                          final int currentTileIndex =
                              (index * 3) + columnIndex + 1;
                          final bool isLevelLocked =
                              levelLockStatus[currentTileIndex - 1];

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTileIndex = currentTileIndex;
                                  isSelected = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        currentTileIndex == selectedTileIndex
                                            ? 'assets/images/level_card selected.png'
                                            : 'assets/images/level_card.png',
                                      ),
                                      isLevelLocked
                                          ? const Icon(
                                              Icons.lock,
                                              size: 38,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              '$currentTileIndex',
                                              style: GoogleFonts.pressStart2p(
                                                color: currentTileIndex ==
                                                        selectedTileIndex
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 36,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          //play button
          Positioned(
              bottom: mediaQuery.height / 6,
              child: GestureDetector(
                onTap: () {
                  _playController.forward().then((value) {
                    playSelected = !playSelected;
                    _playController.reverse();
                  });
                  if(!levelLockStatus[selectedTileIndex - 1]){
                    routerConfig.push(RoutesPath.gameScreen, extra: {'level': selectedTileIndex});
                  }
                },
                child: AnimatedBuilder(
                    animation: _playController,
                    builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (0.1 * _playController.value),
                      child: AnimatedOpacity(
                        opacity: areButtonsVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeIn,
                        child: SizedBox(
                            width: 150,
                            height: 80,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                !playSelected
                                    ? Image.asset('assets/images/button tile.png')
                                    : Image.asset('assets/images/button tile_selected.png')
                                ,
                                Text(
                                  'PLAY',
                                  style: GoogleFonts.pressStart2p(
                                      fontSize: 22, color: Colors.white,
                                      decoration: TextDecoration.none),
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            )),
                      ),
                    );
                  }
                ),
              )),
          //home button
          Positioned(
            bottom: 10.0,
            right: 20.0,
            child: GestureDetector(
              onTap: () {
                _homeController.forward().then((value) {
                  _homeController.reverse();
                });
                routerConfig.pushReplacement(RoutesPath.menuScreen);
              },
              child: AnimatedBuilder(
                animation: _homeController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 - (0.1 * _homeController.value),
                    child: AnimatedOpacity(
                      opacity: areButtonsVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1400),
                      curve: Curves.easeIn,
                      child: Image.asset(
                        'assets/images/home_button.png',
                        width: 60,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          //sound
          Positioned(
            bottom: 10.0,
            left: 20.0,
            child: GestureDetector(
              onTap: () {
                _soundController.forward().then((value) {
                  _soundController.reverse();
                });
                setState(() {
                  isSoundOn = !isSoundOn;
                });
              },
              child: AnimatedOpacity(
                opacity: areButtonsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeIn,
                child: AnimatedBuilder(
                  animation: _soundController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (0.1 * _soundController.value),
                      child: isSoundOn
                          ? Image.asset(
                              'assets/images/soundOn.png',
                              width: 60,
                            )
                          : Image.asset(
                              'assets/images/sound_off.png',
                              width: 60,
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
