import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        Duration(seconds: 1),
        () => routerConfig.push(RoutesPath.gameScreen)
      );
    });
    return const Scaffold(
      body: Center(
        child: Text('splash sceen'),

      ),
    );
  }
}