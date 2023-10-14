
import 'dart:async';

import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/background.dart';
import 'package:brainbots_breakout/src/constants/brick_button.dart';
import 'package:brainbots_breakout/src/constants/color.dart';
import 'dart:io';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin{
  bool isPlayTapped = false;
  bool isLevelTapped = false;
  bool isSettingsTapped = false;
  bool isHowTapped = false;
  bool areButtonsVisible = false;
  bool isSettingsScreen = false;
  double soundVolume = 5;
  double musicVolume = 5;

  late AnimationController _tickController;
  late AnimationController _crossController;


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        areButtonsVisible = true;
      });
    });

    FlameAudio.bgm.initialize();
    if(!FlameAudio.bgm.isPlaying && userConfig.musicOn.value){
      FlameAudio.bgm.play('music/background.mp3');
    }
    userConfig.musicOn.addListener(() {
      if(FlameAudio.bgm.isPlaying && !userConfig.musicOn.value){
        FlameAudio.bgm.stop();
      }
      if(!FlameAudio.bgm.isPlaying && userConfig.musicOn.value){
        FlameAudio.bgm.play('music/background.mp3');
      }
    });


    _tickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _crossController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose(){
    // FlameAudio.bgm.dispose();
    super.dispose();
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
          //menu
          if(!isSettingsScreen ) menuContent(),
          if(isSettingsScreen) Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //settings
              AnimatedOpacity(
                opacity: areButtonsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'SETTINGS',
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
                        'SETTINGS',
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
              80.verticalSpace,
              //sound
              AnimatedOpacity(
                opacity: areButtonsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Text(
                          'SOUND',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.orange.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Positioned(
                          top: 4.0,
                          left: 0.0,
                          child: Text(
                            'SOUND',
                            style: GoogleFonts.pressStart2p(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        MyColor.secondaryColor,
                        BlendMode.hue,
                      ),
                      child: Image.asset('assets/gifs/Cad.gif',
                        width: 60,),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Slider(
                  value: soundVolume,
                  label: 'Sound',
                  autofocus: false,
                  activeColor: MyColor.secondaryColor,
                  inactiveColor: MyColor.appColor,
                  max: 10,
                  min: 1,
                  secondaryActiveColor: MyColor.appColor,
                  onChanged: (value) {
                  setState(() {
                    soundVolume = value;
                  });
                },),
              ),
              //music
              AnimatedOpacity(
                opacity: areButtonsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: Align(
                  alignment: const Alignment(-0.4, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Text(
                            'MUSIC',
                            style: GoogleFonts.pressStart2p(
                              color: Colors.orange.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Positioned(
                            top: 4.0,
                            left: 0.0,
                            child: Text(
                              'MUSIC',
                              style: GoogleFonts.pressStart2p(
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          MyColor.secondaryColor,
                          BlendMode.hue,
                        ),
                        child: Image.asset('assets/gifs/Cad.gif',
                          width: 60,),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Slider(
                  value: musicVolume,
                  label: 'Music',
                  autofocus: false,
                  activeColor: MyColor.secondaryColor,
                  inactiveColor: MyColor.appColor,
                  max: 10,
                  min: 1,
                  secondaryActiveColor: MyColor.appColor,
                  onChanged: (value) {
                  setState(() {
                    musicVolume = value;
                  });
                },),
              ),
              80.verticalSpace,
              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _crossController.forward().then((value) async {
                        _crossController.reverse();
                        await Future.delayed(const Duration(milliseconds: 700));
                        setState(() {
                          isSettingsScreen = !isSettingsScreen;
                          isSettingsTapped = !isSettingsTapped;
                        });
                      });
                    },
                    child: AnimatedBuilder(
                        animation: _crossController,
                        builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 - (0.1 * _crossController.value),
                          child: Stack(
                            children: [
                              Image.asset('assets/images/cross.png', width: 50,
                                color: MyColor.secondaryColor,),
                              Positioned(
                                top: 4,
                                child: Image.asset('assets/images/cross.png', width: 50,
                                  color: MyColor.appColor,),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _tickController.forward().then((value) async {
                        _tickController.reverse();
                        await Future.delayed(const Duration(milliseconds: 700));
                        setState(() {
                          isSettingsScreen = !isSettingsScreen;
                          isSettingsTapped = !isSettingsTapped;
                        });
                      });
                    },
                    child: AnimatedBuilder(
                        animation: _tickController,
                        builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 - (0.1 * _tickController.value),
                          child: Stack(
                            children: [
                              Image.asset('assets/images/tick.png', width: 50,
                                color: MyColor.appColor,),
                              Positioned(
                                top: 4,
                                child: Image.asset('assets/images/tick.png', width: 50,
                                  color: MyColor.secondaryColor,),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Column menuContent() {
    return Column(
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
                onTap: () async {
                  setState(() {
                    isSettingsTapped = !isSettingsTapped;
                  });
                  await Future.delayed(const Duration(milliseconds: 700));
                  setState(() {
                    isSettingsScreen = !isSettingsScreen;
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
                    exit(0);
                },
                isTapped: isHowTapped,
              ),
            ),
          ],
        );
  }
}