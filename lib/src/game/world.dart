import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class World extends ParallaxComponent<Breakout> with HasGameRef<Breakout>{
  @override
  Future<void> onLoad() async{
    parallax = await gameRef.loadParallax([
      
    ]);
  }
}