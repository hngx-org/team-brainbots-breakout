import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const BreakoutGame());
}
class BreakoutGame extends StatelessWidget {
  const BreakoutGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      debugShowCheckedModeBanner: false,
      title: 'Breakout',
    );
  }
}