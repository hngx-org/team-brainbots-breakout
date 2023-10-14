import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  userConfig.init().then((_){
    runApp(const BreakoutGame());
  });
}

class BreakoutGame extends StatelessWidget {
  const BreakoutGame({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(411.4, 868.6),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: routerConfig,
            debugShowCheckedModeBanner: false,
            title: 'Breakout',
          );
        });
  }
}
