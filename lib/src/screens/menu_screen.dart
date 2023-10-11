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
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: Image.asset('assets/images/brick_back.png', fit: BoxFit.cover,),
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
                onTapCancel: () {
                  setState(() {
                    isTapped = false;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    isTapped = false;
                  });
                },
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 150), // Adjust animation duration
                    width: imageSize,
                    height: imageSize,
                child: Image.asset('assets/images/Default@3x.png', width: 100, )),
              ),
              Image.asset('assets/images/SETTINGS3x.png', width: 100, ),
            ],
          ),
        ],
      ),
    );
  }
}
