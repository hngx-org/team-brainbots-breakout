
import 'dart:async';

import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/reusables/background.dart';
import 'package:brainbots_breakout/src/reusables/brick_button.dart';
import 'package:brainbots_breakout/src/constants/color.dart';
import 'dart:io';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
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
  bool isSlidingMusic = false;
  bool isSlidingSound = false;
  bool isHowTapped = false;
  bool areButtonsVisible = false;
  bool isSettingsScreen = false;
  bool isSoundOff = false;
  double soundVolume = 0.5;
  double musicVolume = 0;
  late AnimationController _tickController;
  late AnimationController _crossController;
  late AnimationController _soundController;


  @override
  void initState() {
    super.initState();
    musicVolume = userConfig.musicVolume.value;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        areButtonsVisible = true;
      });
    });

    FlameAudio.bgm.initialize();
    if(!FlameAudio.bgm.isPlaying && userConfig.musicOn.value){
      FlameAudio.bgm.play('music/background.mp3', volume: userConfig.musicVolume.value);
    }
    userConfig.musicOn.addListener(() {
      if(FlameAudio.bgm.isPlaying && !userConfig.musicOn.value){
        FlameAudio.bgm.pause();
      }
      if(!FlameAudio.bgm.isPlaying && userConfig.musicOn.value){
        FlameAudio.bgm.play('music/background.mp3', volume: userConfig.musicVolume.value);
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
    _soundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose(){
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
                    if(isSlidingSound) ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        MyColor.secondaryColor,
                        BlendMode.hue,
                      ),
                      child: Image.asset('assets/gifs/sound_waves.gif',
                        width: 30,),
                    ),
                  ],
                ),
              ),
              // sound slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Slider(
                  value: soundVolume,
                  label: 'Sound',
                  autofocus: false,
                  activeColor: MyColor.secondaryColor,
                  inactiveColor: MyColor.appColor,
                  max: 1,
                  min: 0,
                  secondaryActiveColor: MyColor.appColor,
                  onChangeStart: (value){
                    setState(() {
                      isSlidingSound = true;
                    });
                  },
                  onChangeEnd: (value){
                    setState(() {
                      isSlidingSound = false;
                    });
                     userConfig.sfxVolume.value = value;
                  },
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
                      if(isSlidingMusic) ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          MyColor.secondaryColor,
                          BlendMode.hue,
                        ),
                        child: Image.asset('assets/gifs/sound_waves.gif',
                          width: 30,),
                      ),
                    ],
                  ),
                ),
              ),
              //music slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Slider(
                  value: musicVolume,
                  label: 'Music',
                  autofocus: false,
                  activeColor: MyColor.secondaryColor,
                  inactiveColor: MyColor.appColor,
                  max: 1,
                  min: 0,
                  secondaryActiveColor: MyColor.appColor,
                  onChangeStart: (value){
                    setState(() {
                      isSlidingMusic = true;
                    });
                  },
                  onChangeEnd: (value){
                    setState(() {
                      isSlidingMusic = false;
                    });
                    FlameAudio.bgm.stop();
                    FlameAudio.bgm.play('music/background.mp3', volume: userConfig.musicVolume.value);
                  },
                  onChanged: (value) {
                    setState(() {
                      musicVolume = value;
                      userConfig.musicVolume.value = value;
                    });
                  },),
              ),
              80.verticalSpace,
              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //sound on
                  if(isSoundOff) GestureDetector(
                    onTap: () {
                      _soundController.forward().then((value) async {
                        _soundController.reverse();
                        setState(() {
                          isSoundOff = !isSoundOff;
                          soundVolume = 0.3;
                          musicVolume = 0.3;
                          userConfig.sfxVolume.value = soundVolume;
                          userConfig.musicVolume.value = soundVolume;
                          FlameAudio.bgm.play('music/background.mp3', volume: userConfig.musicVolume.value);
                        });
                      });
                    },
                    child: AnimatedBuilder(
                        animation: _soundController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 - (0.1 * _soundController.value),
                            child: Stack(
                              children: [
                                Image.asset('assets/images/soundOn.png', width: 50,
                                  color: MyColor.secondaryColor,),
                                Positioned(
                                  top: 4,
                                  child: Image.asset('assets/images/soundOn.png', width: 50,
                                    ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                  //sound off
                  if(!isSoundOff) GestureDetector(
                    onTap: () {
                      _soundController.forward().then((value) async {
                        _soundController.reverse();
                        await Future.delayed(const Duration(microseconds: 800));
                        setState(() {
                          isSoundOff = !isSoundOff;
                          soundVolume = 0;
                          musicVolume = 0;
                          userConfig.sfxVolume.value = soundVolume;
                          userConfig.musicVolume.value = soundVolume;
                          FlameAudio.bgm.stop();
                        });
                      });
                    },
                    child: AnimatedBuilder(
                        animation: _soundController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 - (0.1 * _soundController.value),
                            child: Stack(
                              children: [
                                Image.asset('assets/images/sound_off.png', width: 50,
                                  color: MyColor.secondaryColor,),
                                Positioned(
                                  top: 4,
                                  child: Image.asset('assets/images/sound_off.png', width: 50,
                                    ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                  //tick
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
                    routerConfig.pushReplacement(RoutesPath.gameScreen, extra: {'level': userConfig.levelsUnlocked.value});
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