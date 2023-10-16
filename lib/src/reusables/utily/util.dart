import 'dart:math';

import 'package:brainbots_breakout/src/game/sprites/power_up.dart';

class Util {
  static PowerUpType getRandomPowerUpType() {
    final random = Random();
    // final values = PowerUpType.values.where((type) => type != PowerUpType.none).toList();
    final powerUps = [PowerUpType.doubleSize, PowerUpType.halfSize];
    return powerUps[random.nextInt(powerUps.length)];
    // return values[random.nextInt(values.length)];
  }
}
