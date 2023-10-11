import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:brainbots_breakout/src/screens/game_screen.dart';
import 'package:brainbots_breakout/src/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

final GoRouter routerConfig = GoRouter(
  initialLocation: RoutesPath.splash,
  errorBuilder: (context, state) => const Placeholder(),
  routes: [
    GoRoute(
      path: RoutesPath.splash,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const SplashScreen(),
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: RoutesPath.gameScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const GameScreen(),
        key: state.pageKey,
      ),
    ),
  ]
);