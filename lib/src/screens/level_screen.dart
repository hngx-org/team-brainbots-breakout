import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/background.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:flutter/material.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> with TickerProviderStateMixin {
  late AnimationController _homeController;
  late AnimationController _soundController;
  bool isSoundOn = false;

  @override
  void initState() {
    super.initState();
    _homeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Adjust the duration as needed.
    );
     _soundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Adjust the duration as needed.
    );
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomBackground(mediaQuery: mediaQuery), // Assuming you have a CustomBackground widget
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
                  child: Image.asset(
                    'assets/images/home_button.png',
                    width: 60,
                  ),
                );
              },
            ),
          ),
        ),
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
                  )
                  ,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
