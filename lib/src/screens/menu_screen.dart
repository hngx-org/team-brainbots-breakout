import 'package:brainbots_breakout/src/config/router_config.dart';
import 'package:brainbots_breakout/src/constants/routes_path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final imageSize = isTapped ? 80.0 : 100.0;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: Image.asset('assets/images/Stars Small_2.png', fit: BoxFit.cover,),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Breakout',  style: GoogleFonts.pressStart2p(color: Colors.yellowAccent,
              fontWeight: FontWeight.bold, fontSize: 32), textAlign: TextAlign.center,),
              InkWell(
                onTap: () {
                  setState(() {
                    isTapped = true;
                  });
                  routerConfig.pushReplacement(RoutesPath.gameScreen);
                },
                child: Image.asset('assets/images/menu-Tiles.png', width: 100, ),
              ),
              Image.asset('assets/images/menu-Tiles.png', width: 100, ),
            ],
          ),
        ],
      ),
    );
  }
}
