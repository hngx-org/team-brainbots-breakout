import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:brainbots_breakout/src/screens/game_screen.dart';
import 'package:brainbots_breakout/src/screens/level_screen.dart';
import 'package:brainbots_breakout/src/screens/menu_screen.dart';
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
    GoRoute(
      path: RoutesPath.menuScreen,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 700),
            key: state.pageKey,
            child: const MenuScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            });
      }
    ),
    GoRoute(
      path: RoutesPath.levelScreen,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 700),
            key: state.pageKey,
            child: const LevelScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            });
      }
    ),
  ]
);